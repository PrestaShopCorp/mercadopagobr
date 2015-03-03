{**
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
*}

<link rel="stylesheet" type="text/css" href="{$this_path_ssl|escape:'htmlall'}modules/mercadopago/views/css/mercadopago_v6.css">
<h4 id="id-confirmation-standard">
	
	{if $window_type eq 'iframe'}
		<iframe src="{$preferences_url|escape:'htmlall'}" name="MP-Checkout" width="{$iframe_width|escape:'htmlall'}" height="{$iframe_height|escape:'htmlall'}" frameborder="0"/>
	{else}
		<strong>
			{l s='Valor da compra: ' mod='mercadopago'}
			{$amount|escape:'htmlall'}
		</strong>
		</br>
		</br>
		<a href="{$preferences_url|escape:'htmlall'}" class="ch-btn ch-btn-big" id="id-standard" name="MP-Checkout" mp-mode="{$window_type|escape:'htmlall'}" style="float: left;">{l s='Finalizar o pagamento' mod='mercadopago'}	
		</a>
	{/if}
	</br>
	</br>
	</br>
	<span style="background: url({$this_path_ssl|escape:'htmlall'}modules/mercadopago/views/img/payment_method_logo.png) no-repeat;" class="footer-logo"></span>
</h4>
<script type="text/javascript">
  	(function() {
		function $MPBR_load() {
			window.$MPBR_loaded !== true && (function() {
			var s = document.createElement("script");
			s.type = "text/javascript";
			s.async = true;
			s.src = ("https:"==document.location.protocol?"https://www.mercadopago.com/org-img/jsapi/mptools/buttons/":"http://mp-tools.mlstatic.com/buttons/")+"render.js";
			var x = document.getElementsByTagName('script')[0];
			x.parentNode.insertBefore(s, x);
			window.$MPBR_loaded = true;
			})();
		}

	window.$MPBR_loaded !== true ? 
		(window.attachEvent ? window.attachEvent('onload', $MPBR_load) : 
		 window.addEventListener('load', $MPBR_load, false)) : null;
		})();

	// need to set 0 so modal checkout can work
	$("#header").css("z-index", 0);
</script>