{**
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
*}
<link rel="stylesheet" type="text/css" href="/prestashop/modules/mercadopago/css/mercadopago.css">
<h4 id="id-confirmation-boleto">
	<strong>
		{l s='Obrigado pela sua compra!' mod='mercadopago'}
		</br>
		</br>
		<input type="button" style="float: left;" id="id-create-boleto" value="{l s='Gerar boleto' mod='mercadopago'}" class="ch-btn ch-btn-big" />
	</strong>
	</br>
	</br>
	</br>
	<span class="footer-logo"></span>
</h4>
<script type="text/javascript">
	$("#id-create-boleto").click(function () {
		window.open("{$boleto_url}", "_blank");
	});
</script>


