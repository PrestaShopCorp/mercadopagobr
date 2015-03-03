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

<link rel="stylesheet" type="text/css" href="{$this_path_ssl|escape:'htmlall'}modules/mercadopago/views/css/settings.css">
{if $version eq 6}
	{if $success eq 'true'}
	<div class="bootstrap">
		<div class="alert alert-success">
			<button type="button" class="close" data-dismiss="alert">×</button>
			{l s='Configurações atualizadas com sucesso.' mod='mercadopago'}
		</div>
	</div>
	{elseif $errors|@count > 0}
		{foreach from=$errors item=error}
		<div class="bootstrap">
			<div class="alert alert-danger">
				<button type="button" class="close" data-dismiss="alert">×</button>
				{l s='As configurações não foram atualizadas com sucesso.' mod='mercadopago'}
			</div>
		</div>
		<div class="bootstrap">
			<div class="alert alert-danger">
				<button type="button" class="close" data-dismiss="alert">×</button>
				{$error|escape:'htmlall'}
			</div>
		</div>
		{/foreach}
	{/if}
{elseif $version eq 5}
	{if $success eq 'true'}
		<div class="conf">
			{l s='Configurações atualizadas com sucesso.' mod='mercadopago'}
		</div>
	</div>
	{elseif $errors|@count > 0}
		<div class="error">
			{l s='As configurações não foram atualizadas com sucesso.' mod='mercadopago'}
		</div>
		{foreach from=$errors item=error}
		<div class="error">
			{$error|escape:'htmlall'}	
		</div>
		{/foreach}
	{/if}
{/if}
<img src="{$this_path_ssl|escape:'htmlall'}modules/mercadopago/views/img/payment_method_logo_large.png" style="
    margin-top: 30px;">
<form action="{$uri|escape:'htmlall'}" method="post">
	<fieldset style="margin-top: 40px;">
		<legend>
			<img src="../img/admin/contact.gif" />{l s='Configurações - Geral' mod='mercadopago'}
		</legend>
		<label>{l s='Client Id:' mod='mercadopago'}</label>
		<div class="">
			<input type="text" size="33" name="mercadopago_CLIENT_ID" value="{$client_id|escape:'htmlall'}" />
		</div>
		<br />
		<label>{l s='Client Secret:' mod='mercadopago'}</label>
		<div class="">
			<input type="text" size="33" name="mercadopago_CLIENT_SECRET" value="{$client_secret|escape:'htmlall'}" />
		</div>
		<br />
		<label>{l s='Categoria:' mod='mercadopago'}</label>
			<div class=""> 
				<select name="mercadopago_CATEGORY" id="category" style="width: 215px;color: black;background: white;">
					 <option value="art" id="type-checkout-Collectibles &amp; Art">Collectibles &amp; Art</option>
					 <option value="baby" id="type-checkout-Toys for Baby, Stroller, Stroller Accessories, Car Safety Seats">Toys for Baby, Stroller, Stroller Accessories, Car Safety Seats</option>
					 <option value="coupons" id="type-checkout-Coupons">Coupons</option>
					 <option value="donations" id="type-checkout-Donations">Donations</option>
					 <option value="computing" id="type-checkout-Computers &amp; Tablets">Computers &amp; Tablets</option>
					 <option value="cameras" id="type-checkout-Cameras &amp; Photography">Cameras &amp; Photography</option>
					 <option value="video_games" id="type-checkout-Video Games &amp; Consoles">Video Games &amp; Consoles</option>
					 <option value="television" id="type-checkout-LCD, LED, Smart TV, Plasmas, TVs">LCD, LED, Smart TV, Plasmas, TVs</option>
					 <option value="car_electronics" id="type-checkout-Car Audio, Car Alarm Systems &amp; Security, Car DVRs, Car Video Players, Car PC">Car Audio, Car Alarm Systems &amp; Security, Car DVRs, Car Video Players, Car PC</option>
					 <option value="electronics" id="type-checkout-Audio &amp; Surveillance, Video &amp; GPS, Others">Audio &amp; Surveillance, Video &amp; GPS, Others</option>
					 <option value="automotive" id="type-checkout-Parts &amp; Accessories">Parts &amp; Accessories</option>
					 <option value="entertainment" id="type-checkout-Music, Movies &amp; Series, Books, Magazines &amp; Comics, Board Games &amp; Toys">Music, Movies &amp; Series, Books, Magazines &amp; Comics, Board Games &amp; Toys</option>
					 <option value="fashion" id="type-checkout-Men's, Women's, Kids &amp; baby, Handbags &amp; Accessories, Health &amp; Beauty, Shoes, Jewelry &amp; Watches">Men's, Women's, Kids &amp; baby, Handbags &amp; Accessories, Health &amp; Beauty, Shoes, Jewelry &amp; Watches</option>
					 <option value="games" id="type-checkout-Online Games &amp; Credits">Online Games &amp; Credits</option>
					 <option value="home" id="type-checkout-Home appliances. Home &amp; Garden">Home appliances. Home &amp; Garden</option>
					 <option value="musical" id="type-checkout-Instruments &amp; Gear">Instruments &amp; Gear</option>
					 <option value="phones" id="type-checkout-Cell Phones &amp; Accessories">Cell Phones &amp; Accessories</option>
					 <option value="services" id="type-checkout-General services">General services</option>
					 <option value="learnings" id="type-checkout-Trainings, Conferences, Workshops">Trainings, Conferences, Workshops</option>
					 <option value="tickets" id="type-checkout-Tickets for Concerts, Sports, Arts, Theater, Family, Excursions tickets, Events &amp; more">Tickets for Concerts, Sports, Arts, Theater, Family, Excursions tickets, Events &amp; more</option>
					 <option value="travels" id="type-checkout-Plane tickets, Hotel vouchers, Travel vouchers">Plane tickets, Hotel vouchers, Travel vouchers</option>
					 <option value="virtual_goods" id="type-checkout-E-books, Music Files, Software, Digital Images,  PDF Files and any item which can be electronically stored in a file, Mobile Recharge, DTH Recharge and any Online Recharge">E-books, Music Files, Software, Digital Images,  PDF Files and any item which can be electronically stored in a file, Mobile Recharge, DTH Recharge and any Online Recharge</option>
					 <option value="others" id="type-checkout-Other categories" selected="selected">Other categories</option>
				</select>	
			</div>
	</fieldset>
	<fieldset style="margin-top: 40px;">
		<legend>
			<img src="../img/admin/contact.gif" />{l s='Configurações - Cartão de Crédito Transparente' mod='mercadopago'}
		</legend>
		<label>{l s='Ativado: ' mod='mercadopago'}</label>
		<div class="">
			<select name="mercadopago_CREDITCARD_ACTIVE" id="creditcard_active" style="width: 215px;color: black;background: white;">
				<option value="true"> {l s='Sim' mod='mercadopago'}</option>
				<option value="false"> {l s='Não' mod='mercadopago'} </option>
			</select>
		</div>
		<br />
		<label>{l s='Public Key:' mod='mercadopago'}</label>
		<div class="">
			<input type="text" size="33" name="mercadopago_PUBLIC_KEY" value="{$public_key|escape:'htmlall'}" />
		</div>
		<br />
		<label>{l s='Banner:' mod='mercadopago'}</label>
		<div class="">
			<input type="text" size="33" name="mercadopago_CREDITCARD_BANNER" value="{$creditcard_banner|escape:'htmlall'}" />
		</div>
		<br />
	</fieldset>
	<fieldset style="margin-top: 40px;">
		<legend>
			<img src="../img/admin/contact.gif" />{l s='Configurações - Boleto Transparente' mod='mercadopago'}
		</legend>
		<label>{l s='Ativado: ' mod='mercadopago'}</label>
		<div class="">
			<select name="mercadopago_BOLETO_ACTIVE" id="boleto_active"style="width: 215px;color: black;background: white;">
				<option value="true"> {l s='Sim' mod='mercadopago'} </option>
				<option value="false"> {l s='Não' mod='mercadopago'} </option>
			</select>
		</div>
	</fieldset>
	<fieldset style="margin-top: 40px;">
		<legend>
			<img src="../img/admin/contact.gif" />{l s='Configurações - MercadoPago Standard' mod='mercadopago'}
		</legend>
		<label>{l s='Ativado: ' mod='mercadopago'}</label>
		<div class="">
			<select name="mercadopago_STANDARD_ACTIVE" id="standard_active" style="width: 215px;color: black;background: white;">
				<option value="true"> {l s='Sim' mod='mercadopago'} </option>
				<option value="false"> {l s='Não' mod='mercadopago'} </option>
			</select>
		</div>
		<br />
		<label>{l s='Banner:' mod='mercadopago'}</label>
		<div class="">
			<input type="text" size="33" name="mercadopago_STANDARD_BANNER" value="{$standard_banner|escape:'htmlall'}" />
		</div>
		<br />
		<label>{l s='Tipo de checkout:' mod='mercadopago'}</label>
		<div class="">
			<select name="mercadopago_WINDOW_TYPE" id="window_type" style="width: 215px;color: black;background: white;">
				<option value="iframe"> {l s='iFrame' mod='mercadopago'} </option>
				<option value="modal"> {l s='Lightbox' mod='mercadopago'} </option>
				<option value="redirect"> {l s='Redirect' mod='mercadopago'} </option>
			</select>
		</div>
		<br />
		<label>{l s='Excluir os meios de pagamento:' mod='mercadopago'}</label>
		<div class="payment-methods">
			<br />
			<br />
			<input type="checkbox" name="mercadopago_VISA" id="visa" value="{$visa|escape:'htmlall'}"> Visa</input>
			<br />
			<input type="checkbox" name="mercadopago_MASTERCARD" id="mastercard" value="{$mastercard|escape:'htmlall'}"> Mastercard</input>
			<br />
			<input type="checkbox" name="mercadopago_HIPERCARD" id="hipercard" value="{$hipercard|escape:'htmlall'}"> Hipercard</input>
			<br />
			<input type="checkbox" name="mercadopago_AMEX" id="amex" value="{$amex|escape:'htmlall'}"> American Express</input>
			<br />
			<input type="checkbox" name="mercadopago_DINERS" id="diners" value="{$diners|escape:'htmlall'}"> Diners</input>
			<br />
			<input type="checkbox" name="mercadopago_ELO" id="elo" value="{$elo|escape:'htmlall'}"> Elo</input>
			<br />
			<input type="checkbox" name="mercadopago_MELI" id="meli" value="{$meli|escape:'htmlall'}"> Cartão MercadoLivre</input>
			<br />
			<input type="checkbox" name="mercadopago_BOLBRADESCO" id="bolbradesco" value="{$bolbradesco|escape:'htmlall'}"> Boleto</input>
		</div>
		<br />
		<label>{l s='Largura do checkout iFrame:' mod='mercadopago'}</label>
		<div class="">
			<input type="text" size="33" name="mercadopago_IFRAME_WIDTH" value="{$iframe_width|escape:'htmlall'}" />
		</div>
		<br />
		<label>{l s='Altura do checkout iFrame:' mod='mercadopago'}</label>
		<div class="">
			<input type="text" size="33" name="mercadopago_IFRAME_HEIGHT" value="{$iframe_height|escape:'htmlall'}" />
		</div>
		<br />
		<label>{l s='Número máximo de parcelas: ' mod='mercadopago'}</label>
		<div class="">
			<input type="text" size="33" name="mercadopago_INSTALLMENTS" value="{$installments|escape:'htmlall'}" />
		</div>
		<br />
		<label>{l s='Auto Return: ' mod='mercadopago'}</label>
		<div class="">
			<select name="mercadopago_AUTO_RETURN" id="auto_return" style="width: 215px;color: black;background: white;">
				<option value="approved"> {l s='Sim' mod='mercadopago'} </option>
				<option value="false"> {l s='Não' mod='mercadopago'} </option>
			</select>
		</div>
	</fieldset>
	<center>
		<input type="submit" name="submitmercadopago" value="{l s='Atualizar' mod='mercadopago'}" class="ch-btn ch-btn-big"/>
	</center>
</form>
<script type="text/javascript">
	window.onload = function() {
		document.getElementById("category").value = "{$category|escape:'htmlall'}";
		document.getElementById("creditcard_active").value = "{$creditcard_active|escape:'htmlall'}";
		document.getElementById("boleto_active").value = "{$boleto_active|escape:'htmlall'}";
		document.getElementById("standard_active").value = "{$standard_active|escape:'htmlall'}";
		document.getElementById("window_type").value = "{$window_type|escape:'htmlall'}";
		document.getElementById("auto_return").value = "{$auto_return|escape:'htmlall'}";
		document.getElementById("visa").checked = "{$visa|escape:'htmlall'}";
		document.getElementById("mastercard").checked = "{$mastercard|escape:'htmlall'}";
		document.getElementById("hipercard").checked = "{$hipercard|escape:'htmlall'}";
		document.getElementById("amex").checked = "{$amex|escape:'htmlall'}";
		document.getElementById("meli").checked = "{$meli|escape:'htmlall'}";
		document.getElementById("bolbradesco").checked = "{$bolbradesco|escape:'htmlall'}";
		document.getElementById("diners").checked = "{$diners|escape:'htmlall'}";
		document.getElementById("elo").checked = "{$elo|escape:'htmlall'}";
	}

	$("input[type='checkbox']").click(function (e) {
		if ($("#" + e.target.id).attr("checked") !== undefined) {
			$("#" + e.target.id).val("checked");
		} else {
			$("#" + e.target.id).val("")
		}
	});
</script>