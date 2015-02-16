<?php
/**
*
* NOTICE OF LICENSE
*
* This source file is subject to the Open Software License (OSL).
* It is also available through the world-wide-web at this URL:
* http://opensource.org/licenses/osl-3.0.php
*
* @category   	Payment Gateway
* @package    	MercadoPago
* @author      	Ricardo Brito (ricardo.brito@mercadopago.com.br)
* @copyright  	Copyright (c) MercadoPago [http://www.mercadopago.com]
* @license    	http://opensource.org/licenses/osl-3.0.php  Open Software License (OSL 3.0)
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
		$this->version = '3.0';
		$this->currencies = true;
		$this->currencies_mode = 'radio';
		$this->need_instance = 0;
		$this->ps_versions_compliancy = array('min' => '1.6');

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
			array('ffeddb', 'MercadoPago - Transação Devolvida', 'refund', '010010000'),
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
			$file = (dirname(__file__).'/img/mp_icon.gif');
			$newfile = (dirname(dirname(dirname(__file__))).'/img/os/$id_order_state.gif');
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
																			__PS_BASE_URI__.'modules/mercadopago/img/credit_card.png')
			|| !Configuration::updateValue('mercadopago_CREDITCARD_ACTIVE', 'true')
			|| !Configuration::updateValue('mercadopago_BOLETO_ACTIVE', 'true')
			|| !Configuration::updateValue('mercadopago_STANDARD_ACTIVE', 'false')
			|| !Configuration::updateValue('mercadopago_STANDARD_BANNER', 'http://'.htmlspecialchars($_SERVER['HTTP_HOST'], ENT_COMPAT, 'UTF-8').
																			__PS_BASE_URI__.'modules/mercadopago/img/banner_all_methods.png')
			|| !Configuration::updateValue('mercadopago_WINDOW_TYPE', 'modal')
			|| !Configuration::updateValue('mercadopago_IFRAME_WIDTH', '500')
			|| !Configuration::updateValue('mercadopago_IFRAME_HEIGHT', '500')
			|| !Configuration::updateValue('mercadopago_INSTALLMENTS', '12')
			|| !Configuration::updateValue('mercadopago_AUTO_RETURN', 'approved')
			|| !$this->registerHook('payment')
			|| !$this->registerHook('paymentReturn'))
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

			if (!$this->validateCredential($client_id, $client_secret))
			{
				$errors[0] = 'Client id ou client secret inválidos';
				$success = false;
			}
			else
			{
				Configuration::updateValue('mercadopago_CLIENT_ID', $client_id);
				Configuration::updateValue('mercadopago_CLIENT_SECRET', $client_secret);

				$success = true;

				if (!empty($public_key))
					if (!$this->validatePublicKey($client_id, $client_secret, $public_key))
					{
						$errors[1] = 'Public Key inválida.';
						$success = false;
					}
					else
						Configuration::updateValue('mercadopago_PUBLIC_KEY', $public_key);
			}

			$category = Tools::getValue('mercadopago_CATEGORY');
			Configuration::updateValue('mercadopago_CATEGORY', $category);

			$creditcard_active = Tools::getValue('mercadopago_CREDITCARD_ACTIVE');
			Configuration::updateValue('mercadopago_CREDITCARD_ACTIVE', $creditcard_active);

			$creditcard_banner = Tools::getValue('mercadopago_CREDITCARD_BANNER');
			Configuration::updateValue('mercadopago_CREDITCARD_BANNER', $creditcard_banner);

			$boleto_active = Tools::getValue('mercadopago_BOLETO_ACTIVE');
			Configuration::updateValue('mercadopago_BOLETO_ACTIVE', $boleto_active);

			$standard_active = Tools::getValue('mercadopago_STANDARD_ACTIVE');
			Configuration::updateValue('mercadopago_STANDARD_ACTIVE', $standard_active);

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
				'uri' => $_SERVER['REQUEST_URI'],
				'errors' => $errors,
				'success' => $success,
				'this_path_ssl' => Configuration::get('PS_SSL_ENABLED') ? 'https://' : 'http://'
									.htmlspecialchars($_SERVER['HTTP_HOST'], ENT_COMPAT, 'UTF-8').__PS_BASE_URI__

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
			{
				$result = $this->mercadopago->createPreference($this->getPrestashopPreferences(null));

				$data['preferences_url'] = $result['response']['init_point'];
				$data['window_type'] = Configuration::get('mercadopago_WINDOW_TYPE');
				$data['standard_banner'] = Configuration::get('mercadopago_STANDARD_BANNER');

				if ($data['window_type'] == 'iframe')
				{
					$data['iframe_width'] = Configuration::get('mercadopago_IFRAME_WIDTH');
					$data['iframe_height'] = Configuration::get('mercadopago_IFRAME_HEIGHT');
				}
			}

			$this->context->smarty->assign($data);

			return $this->display(__file__, '/views/templates/hook/checkout.tpl');
		}
		else
			return $this->display(__file__, '/views/templates/hook/error.tpl');
	}

	public function hookPaymentReturn()
	{
		if (Tools::getValue('payment_method_id') == 'bolbradesco')
		{
			$this->context->smarty->assign(
				array(
					'boleto_url' => Tools::getValue('boleto_url')
				)
			);
			return $this->display(__file__, '/views/templates/hook/boleto_payment_return.tpl');
		}
		else if (Tools::getValue('checkout') == 'standard')
		{
			$this->context->smarty->assign(
				array(
					'payment_status' => Tools::getValue('payment_status'),
					'payment_id' => Tools::getValue('payment_id')
				)
			);
			return $this->display(__file__, '/views/templates/hook/standard_payment_return.tpl');
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
					'statement_descriptor' => Tools::getValue('statement_descriptor'),
					'payment_id' => Tools::getValue('payment_id'),
					'amount' => Tools::getValue('amount')
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
			'external_reference' => $cart->id,
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
										__PS_BASE_URI__.'index.php?fc=module&module=mercadopago&controller=payment&checkout=standard';
			$data['back_urls']['failure'] = 'http://'.htmlspecialchars($_SERVER['HTTP_HOST'], ENT_COMPAT, 'UTF-8').
										__PS_BASE_URI__.'modules/mercadopago/controllers/front/error.php';
			$data['back_urls']['pending'] = 'http://'.htmlspecialchars($_SERVER['HTTP_HOST'], ENT_COMPAT, 'UTF-8').
										__PS_BASE_URI__.'index.php?fc=module&module=mercadopago&controller=payment&checkout=standard';
			$data['payment_methods']['excluded_payment_methods'] = array();
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
				default:
					$order_status = 'mercadopago_STATUS_3';
					break;
			}

			$id_order = $this->retrieveOrderId($payment_info['external_reference']);
			$this->updateOrderStatus($id_order, Configuration::get($order_status));
		}
	}


	private function retrieveOrderId($id_cart)
	{
		$result = Db::getInstance()->ExecuteS('SELECT id_order FROM '._DB_PREFIX_.'orders WHERE id_cart='.$id_cart);
		return $result ? $result[0]['id_order'] : - 1;
	}

	private function updateOrderStatus($id_order, $status)
	{
		Db::getInstance()->Execute('UPDATE '._DB_PREFIX_.'orders SET current_state='.$status.' WHERE id_order='.$id_order);
		// just update history when new status is different from previous.
		$order_history = Db::getInstance()->ExecuteS('SELECT id_order_history FROM '._DB_PREFIX_.
								'order_history WHERE id_order='.$id_order.' AND id_order_state='.$status.';');
		if (empty($order_history))
			Db::getInstance()->Execute('INSERT INTO '._DB_PREFIX_.'order_history (id_employee, id_order, id_order_state, date_add) VALUES (0, '
										.$id_order.', '.$status.', \''.date('Y-m-d H:i:s').'\')');
	}
}

?>