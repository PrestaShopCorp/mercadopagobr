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

include_once(dirname(__FILE__).'/../../mercadopago.php');

class MercadoPagoCustomPaymentModuleFrontController extends ModuleFrontController {
	public function initContent()
	{
		parent::initContent();
		$this->placeOrder();
	}

	private function placeOrder()
	{
		$cart = Context::getContext()->cart;
		$total = (Float)number_format($cart->getOrderTotal(true, 3), 2, '.', '');
		$mercadopago = MercadoPago::getInstanceByName('mercadopago');

		$extra_vars = array (
					'{bankwire_owner}' => $mercadopago->textshowemail,
					'{bankwire_details}' => '',
					'{bankwire_address}' => ''
					);

		$mercadopago->validateOrder($cart->id, Configuration::get('mercadopago_STATUS_0'),
									$total,
									$mercadopago->displayName,
									null,
									$extra_vars, $cart->id_currency);

		
		$response = $mercadopago->execPayment($_POST);

		$order = new Order($mercadopago->currentOrder);
		$order_payments = $order->getOrderPayments();
		$order_payments[0]->transaction_id = $response['payment_id'];

		$uri = __PS_BASE_URI__.'order-confirmation.php?id_cart='.$cart->id.'&id_module='.$mercadopago->id.
				'&id_order='.$mercadopago->currentOrder.'&key='.$order->secure_key.'&payment_id='.$response['payment_id'].
				'&payment_status='.$response['status'];

		if (Tools::getValue('payment_method_id') == 'bolbradesco')
			$uri .= '&payment_method_id='.Tools::getValue('payment_method_id').'&boleto_url='.urlencode($response['activation_uri']);
		else
		{
			// get credit card last 4 digits
			$four_digits = Tools::substr(Tools::getValue('cardNumber'), -4);
			// expiration date
			$expiration_date = Tools::getValue('cardExpirationMonth').'/20'.Tools::getValue('cardExpirationYear');

			$order_payments[0]->card_number = 'xxxx xxxx xxxx '.$four_digits;
			$order_payments[0]->card_brand = Tools::ucfirst(Tools::getValue('payment_method_id'));
			$order_payments[0]->card_expiration = $expiration_date;
			$order_payments[0]->card_holder = Tools::getValue('cardholderName');

			$uri .= '&card_token='.Tools::getValue('card_token_id').'&card_holder_name='.Tools::getValue('cardholderName').
			'&four_digits='.$four_digits.'&payment_method_id='.Tools::getValue('payment_method_id').
			'&expiration_date='.$expiration_date.'&installments='.$response['installments'].
			'&statement_descriptor='.$response['statement_descriptor'].'&status_detail='.$response['status_detail'].
			'&amount='.$response['amount'];
		}

		$order_payments[0]->save();
		Tools::redirectLink($uri);
	}
}
?>