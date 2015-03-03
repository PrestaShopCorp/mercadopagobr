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

class MercadoPagoStandardCheckoutModuleFrontController extends ModuleFrontController {
	public function initContent()
	{
		parent::initContent();
		$this->setupCheckoutStandard();
	}

	private function setupCheckoutStandard()
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

		$result = $mercadopago->createStandardCheckoutPreference();

		$order = new Order($mercadopago->currentOrder);
		$uri = __PS_BASE_URI__.'order-confirmation.php?id_cart='.$cart->id.'&id_module='.$mercadopago->id.
				'&id_order='.$mercadopago->currentOrder.'&key='.$order->secure_key;

		$uri .= '&checkout=standard';
		$uri .= '&preferences_url='.urlencode($result['response']['init_point']);
		$uri .= '&window_type='.Configuration::get('mercadopago_WINDOW_TYPE');

		if (Configuration::get('mercadopago_WINDOW_TYPE') == 'iframe')
		{
			$uri .= '&iframe_width='.Configuration::get('mercadopago_IFRAME_WIDTH');
			$uri .= '&iframe_height='.Configuration::get('mercadopago_IFRAME_HEIGHT');
		}

		Tools::redirectLink($uri);
	}
}
?>