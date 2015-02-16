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
include_once(dirname(__FILE__).'/../../mercadopago.php');

class MercadoPagoPaymentModuleFrontController extends ModuleFrontController {
	public $ssl = true;
	public $context;

	public function initContent()
	{
		$this->display_column_left = false;
		parent::initContent();

		if (Tools::getValue('checkout') == 'standard')
			$response = $this->parseStandardResponse();
		else
		{
			$mercadopago = MercadoPago::getInstanceByName('mercadopago');
			$response = $mercadopago->execPayment($_POST);
		}
		
		$this->placeOrder($response);
	}

	private function parseStandardResponse()
	{
		$response = array();
		$response['status'] = Tools::getValue('collection_status');
		$response['payment_id'] = Tools::getValue('collection_id');
		$response['payment_type'] = Tools::getValue('payment_type');

		return $response;
	}

	private function placeOrder($response)
	{
		$cart = Context::getContext()->cart;
		$total = (Float)number_format($cart->getOrderTotal(true, 3), 2, '.', '');
		$mercadopago = MercadoPago::getInstanceByName('mercadopago');

		$mail_vars = array (
					'{bankwire_owner}' => $mercadopago->textshowemail,
					'{bankwire_details}' => '',
					'{bankwire_address}' => ''
					);
		$order_status = '';
		$payment_status = $response['status'];

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
		$mercadopago->validateOrder($cart->id, Configuration::get($order_status),
									$total, $mercadopago->displayName.
									(Tools::getValue('payment_method_id') != null ? ' - '.Tools::ucfirst(Tools::getValue('payment_method_id')) : ''),
									'Id Pagamento no MercadoPago: '.$response['payment_id'],
									$mail_vars, $cart->id_currency);
		$order = new Order($mercadopago->currentOrder);

		$uri = __PS_BASE_URI__.'order-confirmation.php?id_cart='.$cart->id.'&id_module='.$mercadopago->id.
				'&id_order='.$mercadopago->currentOrder.'&key='.$order->secure_key.'&payment_id='.$response['payment_id'].
				'&payment_status='.$payment_status;

		if (Tools::getValue('payment_method_id') == 'bolbradesco')
			$uri .= '&payment_method_id='.Tools::getValue('payment_method_id').'&boleto_url='.urlencode($response['activation_uri']);
		else if (Tools::getValue('checkout') == 'standard')
			$uri .= '&checkout=standard';
		else
		{
			// get credit card last 4 digits
			$four_digits = Tools::substr(Tools::getValue('cardNumber'), -4);
			// expiration date
			$expiration_date = Tools::getValue('cardExpirationMonth').'/20'.Tools::getValue('cardExpirationYear');

			$uri .= '&card_token='.Tools::getValue('card_token_id').'&card_holder_name='.Tools::getValue('cardholderName').
			'&four_digits='.$four_digits.'&payment_method_id='.Tools::ucfirst(Tools::getValue('payment_method_id')).
			'&expiration_date='.$expiration_date.'&installments='.$response['installments'].
			'&statement_descriptor='.$response['statement_descriptor'].'&status_detail='.$response['status_detail'].
			'&amount='.$response['amount'];
		}

		Tools::redirectLink($uri);
	}
}
?>