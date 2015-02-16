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
<h4>
	<strong>
		{l s='Obrigado pela sua compra!' mod='mercadopago'}
		{if $payment_status eq 'approved'}
			{l s='O seu pagamento foi aprovado.' mod='mercadopago'}
	</strong>
		</br>
		<h5>
			{l s='Numero de pagamento (MercadoPago): ' mod='mercadopago'}
			{$payment_id|escape:'htmlall'}</br>
		</h5>
		{elseif $payment_status eq 'pending'}
			{l s='O seu pagamento está pendente. Estamos aguardando o pagamento do boleto.' mod='mercadopago'}
		{elseif $payment_status eq 'in_process'}
			{l s='O seu pagamento está pendente.' mod='mercadopago'}</br></br>
			{l s='Estamos processando o pagamento. Em menos de 1 hora, nós enviaremos o resultado por e-mail.' mod='mercadopago'}
		{elseif $payment_status eq 'rejected'}
			{l s='O seu pagamento foi rejeitado. Por favor tente novamente com outro cartão de crédito.' mod='mercadopago'}</br>
		{/if}
</h4>
<span class="footer-logo"></span>