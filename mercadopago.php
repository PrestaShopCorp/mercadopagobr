<?php
/**
* 2007-2015 PrestaShop
*
* NOTICE OF LICENSE
*
* This source file is subject to the Open Software License (OSL 3.0)
* that is bundled with this package in the file LICENSE.txt.
* It is also available through the world-wide-web at this URL:
* http://opensource.org/licenses/osl-3.0.php
* If you did not receive a copy of the license and are unable to
* obtain it through the world-wide-web, please send an email
* to license@prestashop.com so we can send you a copy immediately.
*
* DISCLAIMER
*
* Do not edit or add to this file if you wish to upgrade PrestaShop to newer
* versions in the future. If you wish to customize PrestaShop for your
* needs please refer to http://www.prestashop.com for more information.
*
*  @author    ricardobrito
*  @copyright Copyright (c) MercadoPago [http://www.mercadopago.com]
*  @license   http://opensource.org/licenses/osl-3.0.php  Open Software License (OSL 3.0)
*  International Registered Trademark & Property of MercadoPago
*/

if (!defined('_PS_VERSION_'))
	exit;

function_exists('curl_init');
include(dirname(__FILE__).'/includes/mercadopago.php');

class MercadoPago extends PaymentModule {

	public function __construct()
	{
		$this->name = 'mercadopago';
		$this->tab = 'payments_gateways';
		$this->version = '3.0.0';
		$this->currencies = true;
		$this->currencies_mode = 'radio';
		$this->need_instance = 0;
		$this->ps_versions_compliancy = array('min' => '1.5', 'max' => '1.6');

		parent::__construct();

		$this->page = basename(__file__, '.php');
		$this->displayName = $this->l('MercadoPago');
		$this->description = $this->l('Receba pagamentos via MercadoPago de cartões de créditos 
										e boletos utlizando nosso checkout transparente ou standard.');
		$this->confirmUninstall = $this->l('Você tem certeza que deseja desinstalar MercadoPago?');
		$this->textshowemail = $this->l('Você deve seguir as regras do MercadoPago para sua compra ser válida');
		$this->author = $this->l('MERCADOPAGO.COM REPRESENTAÇÕES LTDA.');

		$this->mercadopago = new MP(Configuration::get('mercadopago_CLIENT_ID'), Configuration::get('mercadopago_CLIENT_SECRET'));
	}

	public function createStates()
	{
		$this->order_state = array(
			array('ccfbff', 'MercadoPago - Transação em Andamento', 'in_analysis', '010010000'),
			array('c9fecd', 'MercadoPago - Transação Concluída', 'payment', '110010010'),
			array('fec9c9', 'MercadoPago - Transação Cancelada', 'order_canceled', '010010000'),
			array('fec9c9', 'MercadoPago - Transação Rejeitada', 'payment_error', '010010000'),
			array('ffeddb', 'MercadoPago - Transação Devolvida', 'refund', '110010000'),
			array('c28566', 'MercadoPago - Transação Contestada', 'charged_back', '010010000'),
			array('b280b2', 'MercadoPago - Transação em Mediação', 'in_mediation', '010010000'),
			array('fffb96', 'MercadoPago - Transação Pendente', 'awaiting_payment', '010010000')
		);

		$languages = Db::getInstance()->ExecuteS(
			'SELECT id_lang, iso_code
			FROM '._DB_PREFIX_.'lang
		');

		foreach ($this->order_state as $key => $value)
		{

			Db::getInstance()->Execute(
				'INSERT INTO '._DB_PREFIX_.
				'order_state (invoice, send_email, module_name, color, unremovable, hidden, logable, delivery, shipped, paid, deleted) 
				VALUES(\''.$value[3][0].'\', \''.$value[3][1].'\',\'mercadopago\', \'#'.$value[0].'\', \''.$value[3][2].
				'\', \''.$value[3][3].'\', \''.$value[3][4].'\', \''.$value[3][5].'\', \''.$value[3][6].'\', \''.$value[3][7].'\', \''.$value[3][8].'\');'
			);

			$sql = 'SELECT MAX(id_order_state) FROM '._DB_PREFIX_.'order_state';
			$id_order_state = Db::getInstance()->getValue($sql);

			foreach ($languages as $language_atual)
			{

				Db::getInstance()->Execute(
					'INSERT INTO '._DB_PREFIX_.
					'order_state_lang (id_order_state, id_lang, name, template)
					VALUES ('.$id_order_state.', '.$language_atual['id_lang'].', \''.$value[1].'\', \''.$value[2].'\');'
				);
			}
			$file = (dirname(__file__).'/views/img/mp_icon.gif');
			$newfile = (dirname(dirname(dirname(__file__))).'/img/os/'.$id_order_state.'.gif');
			if (!copy($file, $newfile))
				return false;

			Configuration::updateValue('mercadopago_STATUS_'.$key, $id_order_state);
		}
		return true;
	}

	public function install()
	{
		$this->createStates();
		if (!parent::install()
			|| !Configuration::updateValue('mercadopago_PUBLIC_KEY', '')
			|| !Configuration::updateValue('mercadopago_CLIENT_ID', '')
			|| !Configuration::updateValue('mercadopago_CLIENT_SECRET', '')
			|| !Configuration::updateValue('mercadopago_CATEGORY', 'others')
			|| !Configuration::updateValue('mercadopago_CREDITCARD_BANNER', 'http://'.htmlspecialchars($_SERVER['HTTP_HOST'], ENT_COMPAT, 'UTF-8').
																			__PS_BASE_URI__.'modules/mercadopago/views/img/credit_card.png')
			|| !Configuration::updateValue('mercadopago_CREDITCARD_ACTIVE', 'true')
			|| !Configuration::updateValue('mercadopago_BOLETO_ACTIVE', 'true')
			|| !Configuration::updateValue('mercadopago_STANDARD_ACTIVE', 'false')
			|| !Configuration::updateValue('mercadopago_STANDARD_BANNER', 'http://'.htmlspecialchars($_SERVER['HTTP_HOST'], ENT_COMPAT, 'UTF-8').
																			__PS_BASE_URI__.'modules/mercadopago/views/img/banner_all_methods.png')
			|| !Configuration::updateValue('mercadopago_WINDOW_TYPE', 'redirect')
			|| !Configuration::updateValue('mercadopago_IFRAME_WIDTH', '725')
			|| !Configuration::updateValue('mercadopago_IFRAME_HEIGHT', '570')
			|| !Configuration::updateValue('mercadopago_INSTALLMENTS', '12')
			|| !Configuration::updateValue('mercadopago_AUTO_RETURN', 'approved')
			|| !Configuration::updateValue('mercadopago_VISA', '')
			|| !Configuration::updateValue('mercadopago_MASTERCARD', '')
			|| !Configuration::updateValue('mercadopago_HIPERCARD', '')
			|| !Configuration::updateValue('mercadopago_AMEX', '')
			|| !Configuration::updateValue('mercadopago_DINERS', '')
			|| !Configuration::updateValue('mercadopago_ELO', '')
			|| !Configuration::updateValue('mercadopago_MELI', '')
			|| !Configuration::updateValue('mercadopago_BOLBRADESCO', '')
			|| !$this->registerHook('payment')
			|| !$this->registerHook('paymentReturn')
			|| !$this->registerHook('displayPaymentTop'))

			return false;

		return true;
	}

	public function uninstall()
	{
		if (!Configuration::deleteByName('mercadopago_PUBLIC_KEY')
			|| !Configuration::deleteByName('mercadopago_CLIENT_ID')
			|| !Configuration::deleteByName('mercadopago_CLIENT_SECRET')
			|| !Configuration::deleteByName('mercadopago_CATEGORY')
			|| !Configuration::deleteByName('mercadopago_CREDITCARD_BANNER')
			|| !Configuration::deleteByName('mercadopago_CREDITCARD_ACTIVE')
			|| !Configuration::deleteByName('mercadopago_BOLETO_ACTIVE')
			|| !Configuration::deleteByName('mercadopago_STANDARD_ACTIVE')
			|| !Configuration::deleteByName('mercadopago_STANDARD_BANNER')
			|| !Configuration::deleteByName('mercadopago_WINDOW_TYPE')
			|| !Configuration::deleteByName('mercadopago_IFRAME_WIDTH')
			|| !Configuration::deleteByName('mercadopago_IFRAME_HEIGHT')
			|| !Configuration::deleteByName('mercadopago_INSTALLMENTS')
			|| !Configuration::deleteByName('mercadopago_AUTO_RETURN')
			|| !Configuration::deleteByName('mercadopago_VISA')
			|| !Configuration::deleteByName('mercadopago_MASTERCARD')
			|| !Configuration::deleteByName('mercadopago_HIPERCARD')
			|| !Configuration::deleteByName('mercadopago_AMEX')
			|| !Configuration::deleteByName('mercadopago_DINERS')
			|| !Configuration::deleteByName('mercadopago_ELO')
			|| !Configuration::deleteByName('mercadopago_MELI')
			|| !Configuration::deleteByName('mercadopago_BOLBRADESCO')
			|| !Configuration::deleteByName('mercadopago_STATUS_0')
			|| !Configuration::deleteByName('mercadopago_STATUS_1')
			|| !Configuration::deleteByName('mercadopago_STATUS_2')
			|| !Configuration::deleteByName('mercadopago_STATUS_3')
			|| !Configuration::deleteByName('mercadopago_STATUS_4')
			|| !Configuration::deleteByName('mercadopago_STATUS_5')
			|| !Configuration::deleteByName('mercadopago_STATUS_6')
			|| !Configuration::deleteByName('mercadopago_STATUS_7')
			|| !parent::uninstall())
			return false;
		return true;
	}

	public function getContent()
	{
		$errors = array();
		$success = false;

		if (Tools::getValue('submitmercadopago'))
		{
			$client_id = Tools::getValue('mercadopago_CLIENT_ID');
			$client_secret = Tools::getValue('mercadopago_CLIENT_SECRET');
			$public_key = Tools::getValue('mercadopago_PUBLIC_KEY');

			$creditcard_active = Tools::getValue('mercadopago_CREDITCARD_ACTIVE');
			$boleto_active = Tools::getValue('mercadopago_BOLETO_ACTIVE');
			$standard_active = Tools::getValue('mercadopago_STANDARD_ACTIVE');

			if (!$this->validateCredential($client_id, $client_secret))
			{
				$errors[] = 'Client id ou client secret inválidos';
				$success = false;
			}
			else
			{
				Configuration::updateValue('mercadopago_CLIENT_ID', $client_id);
				Configuration::updateValue('mercadopago_CLIENT_SECRET', $client_secret);

				$success = true;

				if ($creditcard_active == 'true' && !empty($public_key))
					if (!$this->validatePublicKey($client_id, $client_secret, $public_key))
					{
						$errors[] = 'Public Key inválida.';
						$success = false;
					}
					else
						Configuration::updateValue('mercadopago_PUBLIC_KEY', $public_key);
			}

			$category = Tools::getValue('mercadopago_CATEGORY');
			Configuration::updateValue('mercadopago_CATEGORY', $category);

			$creditcard_banner = Tools::getValue('mercadopago_CREDITCARD_BANNER');
			Configuration::updateValue('mercadopago_CREDITCARD_BANNER', $creditcard_banner);

			if (($creditcard_active == 'false' && $boleto_active == 'false')
				|| (($creditcard_active == 'true' || $boleto_active == 'true') && $standard_active == 'false'))
			{
				Configuration::updateValue('mercadopago_STANDARD_ACTIVE', $standard_active);
				Configuration::updateValue('mercadopago_BOLETO_ACTIVE', $boleto_active);
				Configuration::updateValue('mercadopago_CREDITCARD_ACTIVE', $creditcard_active);
			}
			else
			{
				$errors[] = 'O modo Standard não pode ser habilitado juntamente com o modo Transparente.';
				$success = false;
			}

			$standard_banner = Tools::getValue('mercadopago_STANDARD_BANNER');
			Configuration::updateValue('mercadopago_STANDARD_BANNER', $standard_banner);

			$window_type = Tools::getValue('mercadopago_WINDOW_TYPE');
			Configuration::updateValue('mercadopago_WINDOW_TYPE', $window_type);

			$iframe_width = Tools::getValue('mercadopago_IFRAME_WIDTH');
			Configuration::updateValue('mercadopago_IFRAME_WIDTH', $iframe_width);

			$iframe_height = Tools::getValue('mercadopago_IFRAME_HEIGHT');
			Configuration::updateValue('mercadopago_IFRAME_HEIGHT', $iframe_height);

			$installments = Tools::getValue('mercadopago_INSTALLMENTS');
			Configuration::updateValue('mercadopago_INSTALLMENTS', $installments);

			$auto_return = Tools::getValue('mercadopago_AUTO_RETURN');
			Configuration::updateValue('mercadopago_AUTO_RETURN', $auto_return);

			$visa = Tools::getValue('mercadopago_VISA');
			$mastercard = Tools::getValue('mercadopago_MASTERCARD');
			$hipercard = Tools::getValue('mercadopago_HIPERCARD');
			$amex = Tools::getValue('mercadopago_AMEX');
			$diners = Tools::getValue('mercadopago_DINERS');
			$elo = Tools::getValue('mercadopago_ELO');
			$meli = Tools::getValue('mercadopago_MELI');
			$bolbradesco = Tools::getValue('mercadopago_BOLBRADESCO');

			if (!($visa == 'checked' && $mastercard == 'checked' && $hipercard == 'checked' && $amex == 'checked'
				&& $diners == 'checked' && $elo == 'checked' && $meli == 'checked' && $bolbradesco == 'checked'))
			{
				Configuration::updateValue('mercadopago_VISA', $visa);
				Configuration::updateValue('mercadopago_MASTERCARD', $mastercard);
				Configuration::updateValue('mercadopago_HIPERCARD', $hipercard);
				Configuration::updateValue('mercadopago_AMEX', $amex);
				Configuration::updateValue('mercadopago_DINERS', $diners);
				Configuration::updateValue('mercadopago_ELO', $elo);
				Configuration::updateValue('mercadopago_MELI', $meli);
				Configuration::updateValue('mercadopago_BOLBRADESCO', $bolbradesco);
			}
			else
			{
				$errors[] = 'Habilite pelo menos um método de pagamento.';
				$success = false;
			}
		}

		$this->context->smarty->assign(
			array(
				'public_key' => htmlentities(Configuration::get('mercadopago_PUBLIC_KEY'), ENT_COMPAT, 'UTF-8'),
				'client_id' => htmlentities(Configuration::get('mercadopago_CLIENT_ID'), ENT_COMPAT, 'UTF-8'),
				'client_secret' => htmlentities(Configuration::get('mercadopago_CLIENT_SECRET'), ENT_COMPAT, 'UTF-8'),
				'category' => htmlentities(Configuration::get('mercadopago_CATEGORY'), ENT_COMPAT, 'UTF-8'),
				'creditcard_banner' => htmlentities(Configuration::get('mercadopago_CREDITCARD_BANNER'), ENT_COMPAT, 'UTF-8'),
				'creditcard_active' => htmlentities(Configuration::get('mercadopago_CREDITCARD_ACTIVE'), ENT_COMPAT, 'UTF-8'),
				'boleto_active' => htmlentities(Configuration::get('mercadopago_BOLETO_ACTIVE'), ENT_COMPAT, 'UTF-8'),
				'standard_active' => htmlentities(Configuration::get('mercadopago_STANDARD_ACTIVE'), ENT_COMPAT, 'UTF-8'),
				'standard_banner' => htmlentities(Configuration::get('mercadopago_STANDARD_BANNER'), ENT_COMPAT, 'UTF-8'),
				'window_type' => htmlentities(Configuration::get('mercadopago_WINDOW_TYPE'), ENT_COMPAT, 'UTF-8'),
				'iframe_width' => htmlentities(Configuration::get('mercadopago_IFRAME_WIDTH'), ENT_COMPAT, 'UTF-8'),
				'iframe_height' => htmlentities(Configuration::get('mercadopago_IFRAME_HEIGHT'), ENT_COMPAT, 'UTF-8'),
				'installments' => htmlentities(Configuration::get('mercadopago_INSTALLMENTS'), ENT_COMPAT, 'UTF-8'),
				'auto_return' => htmlentities(Configuration::get('mercadopago_AUTO_RETURN'), ENT_COMPAT, 'UTF-8'),
				'visa' => htmlentities(Configuration::get('mercadopago_VISA'), ENT_COMPAT, 'UTF-8'),
				'mastercard' => htmlentities(Configuration::get('mercadopago_MASTERCARD'), ENT_COMPAT, 'UTF-8'),
				'hipercard' => htmlentities(Configuration::get('mercadopago_HIPERCARD'), ENT_COMPAT, 'UTF-8'),
				'amex' => htmlentities(Configuration::get('mercadopago_AMEX'), ENT_COMPAT, 'UTF-8'),
				'diners' => htmlentities(Configuration::get('mercadopago_DINERS'), ENT_COMPAT, 'UTF-8'),
				'elo' => htmlentities(Configuration::get('mercadopago_ELO'), ENT_COMPAT, 'UTF-8'),
				'meli' => htmlentities(Configuration::get('mercadopago_MELI'), ENT_COMPAT, 'UTF-8'),
				'bolbradesco' => htmlentities(Configuration::get('mercadopago_BOLBRADESCO'), ENT_COMPAT, 'UTF-8'),
				'uri' => $_SERVER['REQUEST_URI'],
				'errors' => $errors,
				'success' => $success,
				'this_path_ssl' => Configuration::get('PS_SSL_ENABLED') ? 'https://' : 'http://'
									.htmlspecialchars($_SERVER['HTTP_HOST'], ENT_COMPAT, 'UTF-8').__PS_BASE_URI__,
				'version' => $this->getPrestashopVersion()

			)
		);

		return $this->display(__file__, '/views/templates/admin/settings.tpl');
	}

	private function validateCredential($client_id, $client_secret)
	{
		$mp = new MP($client_id, $client_secret);
		$result = $mp->getAccessToken();

		return $result ? true : false;
	}

	private function validatePublicKey($client_id, $client_secret, $public_key)
	{
		$mp = new MP($client_id, $client_secret);
		$result = $mp->validatePublicKey($public_key);

		return $result;
	}

	public function hookDisplayPaymentTop()
	{
		$data = array(
				'creditcard_active' => Configuration::get('mercadopago_CREDITCARD_ACTIVE'),
				'public_key' => Configuration::get('mercadopago_PUBLIC_KEY')
		);

		$this->context->smarty->assign($data);

		return $this->display(__file__, '/views/templates/hook/payment_top.tpl');
	}

	public function hookPayment($params)
	{
		if ($this->hasCredential())
		{
			$data = array(
				'this_path_ssl' => Configuration::get('PS_SSL_ENABLED') ? 'https://' : 'http://'
									.htmlspecialchars($_SERVER['HTTP_HOST'], ENT_COMPAT, 'UTF-8').__PS_BASE_URI__,
				'boleto_active' => Configuration::get('mercadopago_BOLETO_ACTIVE'),
				'creditcard_active' => Configuration::get('mercadopago_CREDITCARD_ACTIVE'),
				'standard_active' => Configuration::get('mercadopago_STANDARD_ACTIVE')
			);

			// send credit card configurations only activated
			if (Configuration::get('mercadopago_CREDITCARD_ACTIVE') == 'true')
			{
				$data['public_key'] = Configuration::get('mercadopago_PUBLIC_KEY');
				$data['creditcard_banner'] = Configuration::get('mercadopago_CREDITCARD_BANNER');
				$data['amount'] = (Float)number_format($params['cart']->getOrderTotal(true, 3), 2, '.', '');
			}

			// send standard configurations only activated
			if (Configuration::get('mercadopago_STANDARD_ACTIVE') == 'true')
				$data['standard_banner'] = Configuration::get('mercadopago_STANDARD_BANNER');

			$this->context->smarty->assign($data);

			if ($this->getPrestashopVersion() == 6)
				return $this->display(__file__, '/views/templates/hook/checkout_v6.tpl');
			else
				return $this->display(__file__, '/views/templates/hook/checkout_v5.tpl');
		}
		else
		{
			$data = array();
			$data['version'] = $this->getPrestashopVersion();
			$this->context->smarty->assign($data);

			return $this->display(__file__, '/views/templates/hook/error.tpl');
		}
	}

	public function hookPaymentReturn($params)
	{
		if (Tools::getValue('payment_method_id') == 'bolbradesco')
		{
			$this->context->smarty->assign(
				array(
					'payment_id' => Tools::getValue('payment_id'),
					'boleto_url' => Tools::getValue('boleto_url'),
					'this_path_ssl' => Configuration::get('PS_SSL_ENABLED') ? 'https://' : 'http://'
									.htmlspecialchars($_SERVER['HTTP_HOST'], ENT_COMPAT, 'UTF-8').__PS_BASE_URI__
				)
			);
			return $this->display(__file__, '/views/templates/hook/boleto_payment_return.tpl');
		}
		else if (Tools::getValue('checkout') == 'standard')
		{
			$data = array();
			$data['amount'] = Tools::displayPrice($params['total_to_pay'], $params['currencyObj'], false);
			$data['preferences_url'] = Tools::getValue('preferences_url');
			$data['window_type'] = Tools::getValue('window_type');
			$data['standard_banner'] = Tools::getValue('standard_banner');
			$data['this_path_ssl'] = Configuration::get('PS_SSL_ENABLED') ? 'https://' : 'http://'
									.htmlspecialchars($_SERVER['HTTP_HOST'], ENT_COMPAT, 'UTF-8').__PS_BASE_URI__;

			if ($data['window_type'] == 'iframe')
			{
				$data['iframe_width'] = Tools::getValue('iframe_width');
				$data['iframe_height'] = Tools::getValue('iframe_height');
			}

			$this->context->smarty->assign($data);

			return $this->display(__file__, '/views/templates/hook/standard_checkout.tpl');
		}
		else
		{
			$this->context->smarty->assign(
				array(
					'payment_status' => Tools::getValue('payment_status'),
					'status_detail' => Tools::getValue('status_detail'),
					'card_holder_name' => Tools::getValue('card_holder_name'),
					'four_digits' => Tools::getValue('four_digits'),
					'payment_method_id' => Tools::getValue('payment_method_id'),
					'expiration_date' => Tools::getValue('expiration_date'),
					'installments' => Tools::getValue('installments'),
					'transaction_amount' => Tools::displayPrice(Tools::getValue('transaction_amount'), $params['currencyObj'], false),
					'statement_descriptor' => Tools::getValue('statement_descriptor'),
					'payment_id' => Tools::getValue('payment_id'),
					'amount' => Tools::displayPrice($params['total_to_pay'], $params['currencyObj'], false),
					'this_path_ssl' => Configuration::get('PS_SSL_ENABLED') ? 'https://' : 'http://'
									.htmlspecialchars($_SERVER['HTTP_HOST'], ENT_COMPAT, 'UTF-8').__PS_BASE_URI__
				)
			);

			return $this->display(__file__, '/views/templates/hook/creditcard_payment_return.tpl');
		}
	}

	private function hasCredential()
	{
		return Configuration::get('mercadopago_CLIENT_ID') != '' && Configuration::get('mercadopago_CLIENT_SECRET') != '';
	}

	public function execPayment($post)
	{
		$result = $this->mercadopago->createCustomPayment($this->getPrestashopPreferences($post));
		return $result['response'];
	}

	private function getPrestashopPreferences($post)
	{
		$customer = Context::getContext()->customer;
		$customer_fields = $customer->getFields();
		$cart = Context::getContext()->cart;

		//Get shipment data
		$address_delivery = new Address((Integer)$cart->id_address_delivery);
		$shipments = array(
			'receiver_address' => array(
				'floor' => '-',
				'zip_code' => $address_delivery->postcode,
				'street_name' => $address_delivery->address1.' - '.$address_delivery->address2.' - '.$address_delivery->city.'/'.$address_delivery->country,
				'apartment' => '-',
				'street_number' => '-'
				)
		);

		// Get costumer data
		$address_invoice = new Address((Integer)$cart->id_address_invoice);
		$phone = $address_invoice->phone;
		$phone .= $phone == '' ? '' : '|';
		$phone .= $address_invoice->phone_mobile;
		$customer = array(
			'first_name' => $customer_fields['firstname'],
			'last_name' => $customer_fields['lastname'],
			'email' => $customer_fields['email'],
			'phone' => array(
				'area_code' => '-',
				'number' => $phone
			),
			'address' => array(
				'zip_code' => $address_invoice->postcode,
				'street_name' => $address_invoice->address1.' - '.$address_invoice->address2.' - '.
									$address_invoice->city.'/'.$address_invoice->country,
				'street_number' => '-'
			),
			// just have this data when using credit card
			'identification' => array(
				'number' => $post != null && array_key_exists('docNumber', $post) ? $post['docNumber'] : '',
				'type' => $post != null && array_key_exists('docType', $post) ? $post['docType'] : ''
			)
		);
		//items
		$image_url = '';
		$products = $cart->getProducts();
		$items = array();

		foreach ($products as $product)
		{
			$image_url = '';
			// get image URL
			if (!empty($product['id_image']))
			{
				$image = new Image($product['id_image']);
				$image_url = _PS_BASE_URL_._THEME_PROD_DIR_.$image->getExistingImgPath().'.'.$image->image_format;
			}

			$item = array (
				'id' => $product['id_product'],
				'title' => utf8_encode($product['description_short']),
				'description' => utf8_encode($product['description_short']),
				'quantity' => $product['quantity'],
				'unit_price' => $product['price_wt'],
				'picture_url'=> $image_url,
				'category_id'=> Configuration::get('mercadopago_CATEGORY')
			);

			$items[] = $item;
		}

		$data = array(
			'external_reference' => $this->currentOrder,
			'customer' => $customer,
			'items' => $items,
			'shipments' => $shipments,
			'notification_url' => 'http://'.htmlspecialchars($_SERVER['HTTP_HOST'], ENT_COMPAT, 'UTF-8').
									__PS_BASE_URI__.'modules/mercadopago/controllers/front/notification.php'
		);

		if ($post != null && (array_key_exists('card_token_id', $post) ||
			(array_key_exists('payment_method_id', $post) && $post['payment_method_id'] == 'bolbradesco')))
		{
			$customer = Context::getContext()->customer;
			$customer_fields = $customer->getFields();
			$cart = Context::getContext()->cart;

			$data['reason'] = 'Prestashop via MercadoPago';
			$data['amount'] = (Float)number_format($cart->getOrderTotal(true, 3), 2, '.', '');
			$data['payer_email'] = $customer_fields['email'];

			// add only for creditcard
			if (array_key_exists('card_token_id', $post))
			{
				$data['card_token_id'] = $post['card_token_id'];
				$data['installments'] = (Integer)$post['installments'];
			}
			// add only for boleto
			else
				$data['payment_method_id'] = $post['payment_method_id'];
		}
		else
		{
			$data['auto_return'] = Configuration::get('mercadopago_AUTO_RETURN') == 'approved' ? 'approved' : '';
			$data['back_urls']['success'] = 'http://'.htmlspecialchars($_SERVER['HTTP_HOST'], ENT_COMPAT, 'UTF-8').
										__PS_BASE_URI__.'index.php?fc=module&module=mercadopago&controller=standardreturn';
			$data['back_urls']['failure'] = 'http://'.htmlspecialchars($_SERVER['HTTP_HOST'], ENT_COMPAT, 'UTF-8').
										__PS_BASE_URI__.'index.php?fc=module&module=mercadopago&controller=standardreturn';
			$data['back_urls']['pending'] = 'http://'.htmlspecialchars($_SERVER['HTTP_HOST'], ENT_COMPAT, 'UTF-8').
										__PS_BASE_URI__.'index.php?fc=module&module=mercadopago&controller=standardreturn';
			$data['payment_methods']['excluded_payment_methods'] = $this->getExcludedPaymentMethods();
			$data['payment_methods']['excluded_payment_types'] = array();
			$data['payment_methods']['installments'] = (Integer)Configuration::get('mercadopago_INSTALLMENTS');

			// swap to payer index since customer is only for transparent
			$data['customer']['name'] = $data['customer']['first_name'];
			$data['customer']['surname'] = $data['customer']['last_name'];
			$data['payer'] = $data['customer'];
			unset($data['customer']);
		}
		return $data;
	}

	public function createStandardCheckoutPreference()
	{
		return $this->mercadopago->createPreference($this->getPrestashopPreferences(null));
	}

	private function getExcludedPaymentMethods()
	{
		$excluded_payment_methods = array();

		if (Configuration::get('mercadopago_VISA') == 'checked')
			$excluded_payment_methods[] = array('id' => 'visa');
		if (Configuration::get('mercadopago_MASTERCARD') == 'checked')
			$excluded_payment_methods[] = array('id' => 'master');
		if (Configuration::get('mercadopago_HIPERCARD') == 'checked')
			$excluded_payment_methods[] = array('id' => 'hipercard');
		if (Configuration::get('mercadopago_AMEX') == 'checked')
			$excluded_payment_methods[] = array('id' => 'amex');
		if (Configuration::get('mercadopago_DINERS') == 'checked')
			$excluded_payment_methods[] = array('id' => 'diners');
		if (Configuration::get('mercadopago_ELO') == 'checked')
			$excluded_payment_methods[] = array('id' => 'elo');
		if (Configuration::get('mercadopago_MELI') == 'checked')
			$excluded_payment_methods[] = array('id' => 'melicard');
		if (Configuration::get('mercadopago_BOLBRADESCO') == 'checked')
			$excluded_payment_methods[] = array('id' => 'bolbradesco');

		return $excluded_payment_methods;
	}

	public function updateOrder($topic, $id)
	{
		if ($topic == 'payment' && $id > 0)
		{
			// get payment info
			$result = $this->mercadopago->getPayment($id);
			$payment_info = $result['response']['collection'];
			$payment_status = $payment_info['status'];
			$order_status = '';
			switch ($payment_status)
			{
				case 'in_process':
					$order_status = 'mercadopago_STATUS_0';
					break;
				case 'approved':
					$order_status = 'mercadopago_STATUS_1';
					break;
				case 'cancelled':
					$order_status = 'mercadopago_STATUS_2';
					break;
				case 'refunded':
					$order_status = 'mercadopago_STATUS_4';
					break;
				case 'charged_back':
					$order_status = 'mercadopago_STATUS_5';
					break;
				case 'in_mediation':
					$order_status = 'mercadopago_STATUS_6';
					break;
				case 'pending':
					$order_status = 'mercadopago_STATUS_7';
					break;
				case 'rejected':
					$order_status = 'mercadopago_STATUS_3';
					break;
			}
			$id_order = $payment_info['external_reference'];

			$order = new Order($id_order);

			// Only update if previous state is different from new state
			if ($order->current_state != null && $order->current_state != Configuration::get($order_status))
			{
				$this->updateOrderHistory($id_order, Configuration::get($order_status));

				// update order payment information
				$order_payments = $order->getOrderPayments();
				$order_payments[0]->transaction_id = $payment_info['id'];
				if ($payment_info['payment_type'] == 'credit_card')
				{
					$order_payments[0]->card_number = 'xxxx xxxx xxxx '.$payment_info['last_four_digits'];
					$order_payments[0]->card_brand = Tools::ucfirst($payment_info['payment_method_id']);
					$order_payments[0]->card_holder = $payment_info['cardholder']['name'];
					//card_expiration just custom checkout has it. Can't fecht it thru collections
				}
				$order_payments[0]->save();

				// Cancel the order to force products to go to stock.
				switch ($payment_status)
				{
					case 'cancelled':
					case 'refunded':
					case 'charged_back':
					case 'rejected':
						$this->updateOrderHistory($id_order, Configuration::get('PS_OS_CANCELED'), false);
					break;
				}
			}
		}
	}


	private function updateOrderHistory($id_order, $status, $mail = true)
	{
		// Change order state and send email
		$history = new OrderHistory();
		$history->id_order = (Integer)$id_order;
		$history->changeIdOrderState((Integer)$status, (Integer)$id_order, true);
		if ($mail)
		{
			$extra_vars = array();
			$history->addWithemail(true, $extra_vars);
		}
	}

	public function getPrestashopVersion()
	{
		if (version_compare(_PS_VERSION_, '1.6.0.1', '>='))
			$version = 6;
		else if (version_compare(_PS_VERSION_, '1.5.0.1', '>='))
			$version = 5;
		else
			$version = 4;

		return $version;
	}
}

?>