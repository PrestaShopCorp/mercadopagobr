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
<div class="mp-module">
	{include file='./marketing.tpl' this_path_ssl=$this_path_ssl|escape:'htmlall'}
	<div id="settings">
	<div id="alerts">
	{if $version eq 6}
		{if $success eq 'true'}
		<div id="alert" class="bootstrap">
			<div class="alert alert-success">
				<button type="button" class="close" data-dismiss="alert">×</button>
				{l s='Settings changed successfully.' mod='mercadopagobr'}
			</div>
		</div>
		{elseif $errors|@count > 0}
			{foreach from=$errors item=error}
			<div class="bootstrap">
				<div class="alert alert-danger">
					<button type="button" class="close" data-dismiss="alert">×</button>
					{l s='Settings failed to change.' mod='mercadopagobr'}
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
				{l s='Settings changed successfully.' mod='mercadopagobr'}
			</div>
		</div>
		{elseif $errors|@count > 0}
			<div class="error">
				{l s='Settings failed to change.' mod='mercadopagobr'}
			</div>
			{foreach from=$errors item=error}
			<div class="error">
				{$error|escape:'htmlall'}	
			</div>
			{/foreach}
		{/if}
	{/if}
	</div>
	<img class="logo" src="{$this_path_ssl|escape:'htmlall'}modules/mercadopagobr/views/img/payment_method_logo_large.png">
	</br>
	</br>
	</br>
	<h3> {l s='Notes:' mod='mercadopagobr'}</h3>
	<h4> {l s='- To obtain your Client Id and Client Secret please access: ' mod='mercadopagobr'}
		<a href="https://www.mercadopago.com/mlb/ferramentas/aplicacoes"><u>https://www.mercadopago.com/mlb/ferramentas/aplicacoes</u></a>
	</h4>
	<h4> {l s='- To get and activate your production public_key, please follow the steps "What do I need to go to production?" and "I want to go to production" in the following address: ' mod='mercadopagobr'}
		<a href="https://www.mercadopago.com/mlb/account/credentials">https://www.mercadopago.com/mlb/account/credentials</a>
	</h4>
	<form action="{$uri|escape:'htmlall'}" method="post">
		<fieldset>
			<legend>
				<img src="../img/admin/contact.gif" />{l s='Settings - General' mod='mercadopagobr'}
			</legend>
			<label>{l s='Client Id:' mod='mercadopagobr'}</label>
			<div class="">
				<input type="text" size="33" name="MERCADOPAGO_CLIENT_ID" value="{$client_id|escape:'htmlall'}" />
			</div>
			<br />
			<label>{l s='Client Secret:' mod='mercadopagobr'}</label>
			<div class="">
				<input type="text" size="33" name="MERCADOPAGO_CLIENT_SECRET" value="{$client_secret|escape:'htmlall'}" />
			</div>
			<br />
			<label>{l s='Category:' mod='mercadopagobr'}</label>
				<div class=""> 
					<select name="MERCADOPAGO_CATEGORY" id="category">
						 <option value="art">{l s='Collectibles & Art' mod='mercadopagobr'}</option>
						 <option value="baby">{l s='Toys for Baby, Stroller, Stroller Accessories, Car Safety Seats' mod='mercadopagobr'}</option>
						 <option value="coupons">{l s='Coupons' mod='mercadopagobr'}</option>
						 <option value="donations">{l s='Donations' mod='mercadopagobr'}</option>
						 <option value="computing">{l s='Computers & Tablets' mod='mercadopagobr'}</option>
						 <option value="cameras">{l s='Cameras & Photography' mod='mercadopagobr'}</option>
						 <option value="video_games">{l s='Video Games & Consoles' mod='mercadopagobr'}</option>
						 <option value="television">{l s='LCD, LED, Smart TV, Plasmas, TVs' mod='mercadopagobr'}</option>
						 <option value="car_electronics">{l s='Car Audio, Car Alarm Systems & Security, Car DVRs, Car Video Players, Car PC' mod='mercadopagobr'}</option>
						 <option value="electronics">{l s='Audio & Surveillance, Video & GPS, Others' mod='mercadopagobr'}</option>
						 <option value="automotive">{l s='Parts & Accessories' mod='mercadopagobr'}</option>
						 <option value="entertainment">{l s='Music, Movies & Series, Books, Magazines & Comics, Board Games & Toys' mod='mercadopagobr'}</option>
						 <option value="fashion">{l s='Men\'s, Women\'s, Kids & baby, Handbags & Accessories, Health & Beauty, Shoes, Jewelry & Watches' mod='mercadopagobr'}</option>
						 <option value="games"> {l s='Online Games & Credits' mod='mercadopagobr'}</option>
						 <option value="home">{l s='Home appliances. Home & Garden' mod='mercadopagobr'}</option>
						 <option value="musical">{l s='Instruments & Gear' mod='mercadopagobr'}</option>
						 <option value="phones">{l s='Cell Phones & Accessories' mod='mercadopagobr'}</option>
						 <option value="services">{l s='General services' mod='mercadopagobr'}</option>
						 <option value="learnings" >{l s='Trainings, Conferences, Workshops' mod='mercadopagobr'}</option>
						 <option value="tickets">{l s='Tickets for Concerts, Sports, Arts, Theater, Family, Excursions tickets, Events & more' mod='mercadopagobr'}</option>
						 <option value="travels">{l s='Plane tickets, Hotel vouchers, Travel vouchers' mod='mercadopagobr'}</option>
						 <option value="virtual_goods">{l s='E-books, Music Files, Software, Digital Images,  PDF Files and any item which can be electronically stored in a file, Mobile Recharge, DTH Recharge and any Online Recharge' mod='mercadopagobr'}</option>
						 <option value="others" selected="selected">{l s='Other categories' mod='mercadopagobr'}</option>
					</select>	
				</div>
				<br/>
				<label>{l s='Notification URL:' mod='mercadopagobr'}</label>
				<div>{$notification_url|escape:'javascript'}</div>

				<br />					
		</fieldset>
		<fieldset>
			<legend>
				<img src="../img/admin/contact.gif" />{l s='Settings - Custom Credit Card' mod='mercadopagobr'}
			</legend>
			<label>{l s='Active: ' mod='mercadopagobr'}</label>
			<div class="">
				<select name="MERCADOPAGO_CREDITCARD_ACTIVE" id="creditcard_active">
					<option value="true">{l s='Yes' mod='mercadopagobr'}</option>
					<option value="false">{l s='No' mod='mercadopagobr'} </option>
				</select>
			</div>
			<br />
			<label>{l s='Production Public Key:' mod='mercadopagobr'}</label>
			<div class="">
				<input type="text" size="33" name="MERCADOPAGO_PUBLIC_KEY" value="{$public_key|escape:'htmlall'}" />
			</div>
			<br />
			<label>{l s='Banner:' mod='mercadopagobr'}</label>
			<div class="">
				<input type="text" size="33" name="MERCADOPAGO_CREDITCARD_BANNER" value="{$creditcard_banner|escape:'htmlall'}" />
			</div>
			<br />		
		</fieldset>
		<fieldset>
			<legend>
				<img src="../img/admin/contact.gif" />{l s='Settings - Custom Ticket' mod='mercadopagobr'}
			</legend>
			<label>{l s='Active: ' mod='mercadopagobr'}</label>
			<div class="">
				<select name="MERCADOPAGO_BOLETO_ACTIVE" id="boleto_active">
					<option value="true">{l s='Yes' mod='mercadopagobr'} </option>
					<option value="false">{l s='No' mod='mercadopagobr'} </option>
				</select>
			</div>
		</fieldset>
		<fieldset>
			<legend>
				<img src="../img/admin/contact.gif" />{l s='Settings - MercadoPago Standard' mod='mercadopagobr'}
			</legend>
			<label>{l s='Active: ' mod='mercadopagobr'}</label>
			<div class="">
				<select name="MERCADOPAGO_STANDARD_ACTIVE" id="standard_active">
					<option value="true">{l s='Yes' mod='mercadopagobr'} </option>
					<option value="false">{l s='No' mod='mercadopagobr'} </option>
				</select>
			</div>
			<br />
			<label>{l s='Banner:' mod='mercadopagobr'}</label>
			<div class="">
				<input type="text" size="33" name="MERCADOPAGO_STANDARD_BANNER" value="{$standard_banner|escape:'htmlall'}" />
			</div>
			<br />
			<label>{l s='Checkout window:' mod='mercadopagobr'}</label>
			<div class="">
				<select name="MERCADOPAGO_WINDOW_TYPE" id="window_type">
					<option value="iframe">{l s='iFrame' mod='mercadopagobr'} </option>
					<!-- <option value="modal">{l s='Lightbox' mod='mercadopagobr'} </option> -->
					<option value="redirect">{l s='Redirect' mod='mercadopagobr'} </option>
				</select>
			</div>
			<br />
			<label>{l s='Exclude payment methods:' mod='mercadopagobr'}</label>
			<div class="payment-methods">
				<br />
				<br />
				<input type="checkbox" name="MERCADOPAGO_VISA" id="visa" value="{$visa|escape:'htmlall'}">{l s='Visa' mod='mercadopagobr'}</input>
				<br />
				<input type="checkbox" name="MERCADOPAGO_MASTERCARD" id="mastercard" value="{$mastercard|escape:'htmlall'}">{l s='Mastercard' mod='mercadopagobr'}</input>
				<br />
				<input type="checkbox" name="MERCADOPAGO_HIPERCARD" id="hipercard" value="{$hipercard|escape:'htmlall'}">{l s='Hipercard' mod='mercadopagobr'}</input>
				<br />
				<input type="checkbox" name="MERCADOPAGO_AMEX" id="amex" value="{$amex|escape:'htmlall'}">{l s='American Express' mod='mercadopagobr'}</input>
				<br />
				<input type="checkbox" name="MERCADOPAGO_DINERS" id="diners" value="{$diners|escape:'htmlall'}">{l s='Diners' mod='mercadopagobr'}</input>
				<br />
				<input type="checkbox" name="MERCADOPAGO_ELO" id="elo" value="{$elo|escape:'htmlall'}">{l s='Elo' mod='mercadopagobr'}</input>
				<br />
				<input type="checkbox" name="MERCADOPAGO_MELI" id="meli" value="{$meli|escape:'htmlall'}">{l s='MercadoLibre Card' mod='mercadopagobr'}</input>
				<br />
				<input type="checkbox" name="MERCADOPAGO_BOLBRADESCO" id="bolbradesco" value="{$bolbradesco|escape:'htmlall'}">{l s='Ticket' mod='mercadopagobr'}</input>
			</div>
			<br />
			<label>{l s='iFrame width:' mod='mercadopagobr'}</label>
			<div class="">
				<input type="text" size="33" name="MERCADOPAGO_IFRAME_WIDTH" value="{$iframe_width|escape:'htmlall'}" />
			</div>
			<br />
			<label>{l s='iFrame height:' mod='mercadopagobr'}</label>
			<div class="">
				<input type="text" size="33" name="MERCADOPAGO_IFRAME_HEIGHT" value="{$iframe_height|escape:'htmlall'}" />
			</div>
			<br />
			<label>{l s='Max installments:' mod='mercadopagobr'}</label>
			<div class="">
				<input type="text" size="33" name="MERCADOPAGO_INSTALLMENTS" value="{$installments|escape:'htmlall'}" />
			</div>
			<br />
			<label>{l s='Auto Return: ' mod='mercadopagobr'}</label>
			<div class="">
				<select name="MERCADOPAGO_AUTO_RETURN" id="auto_return">
					<option value="approved">{l s='Yes' mod='mercadopagobr'} </option>
					<option value="false">{l s='No' mod='mercadopagobr'} </option>
				</select>
			</div>
		</fieldset>

		<fieldset>
			<legend>
				<img src="../img/admin/contact.gif" />{l s='Settings - Active log' mod='mercadopagobr'}
			</legend>
			<label>{l s='Active: ' mod='mercadopagobr'}</label>
			<div class="">
				<select name="MERCADOPAGO_LOG" id="log_active">
					<option value="true">{l s='Yes' mod='mercadopagobr'} </option>
					<option value="false">{l s='No' mod='mercadopagobr'} </option>
				</select>
			</div>
		</fieldset>
		<center>
			<input type="submit" name="submitmercadopagobr" value="{l s='Save' mod='mercadopagobr'}" class="ch-btn ch-btn-big"/>
			<input type="button" id="back" value="{l s='Back' mod='mercadopagobr'}" class="ch-btn-orange ch-btn-big-orange"/>
		</center>
	</form>
</div>
<script type="text/javascript">
	$(document).ready(function (){
		// hide marketing when settings are updated
		if ($("#alerts").children().length > 0) {
			$(".marketing").hide();
			$("#settings").show();
			$.scrollTo(0, 0);
		}
	})
	
	window.onload = function() {
		document.getElementById("category").value = "{$category|escape:'javascript'}";
		document.getElementById("creditcard_active").value = "{$creditcard_active|escape:'javascript'}";
		document.getElementById("boleto_active").value = "{$boleto_active|escape:'javascript'}";
		document.getElementById("standard_active").value = "{$standard_active|escape:'javascript'}";
		document.getElementById("log_active").value = "{$log_active|escape:'javascript'}";
		document.getElementById("window_type").value = "{$window_type|escape:'javascript'}";
		document.getElementById("auto_return").value = "{$auto_return|escape:'javascript'}";
		document.getElementById("visa").checked = "{$visa|escape:'javascript'}";
		document.getElementById("mastercard").checked = "{$mastercard|escape:'javascript'}";
		document.getElementById("hipercard").checked = "{$hipercard|escape:'javascript'}";
		document.getElementById("amex").checked = "{$amex|escape:'javascript'}";
		document.getElementById("meli").checked = "{$meli|escape:'javascript'}";
		document.getElementById("bolbradesco").checked = "{$bolbradesco|escape:'javascript'}";
		document.getElementById("diners").checked = "{$diners|escape:'javascript'}";
		document.getElementById("elo").checked = "{$elo|escape:'javascript'}";
	}

	$("input[type='checkbox']").click(function (e) {
		if ($("#" + e.target.id).attr("checked") !== undefined) {
			$("#" + e.target.id).val("checked");
		} else {
			$("#" + e.target.id).val("")
		}
	});

	$("#back").click(
		function() { 
			$(".marketing").show();
			$("#settings").hide();
			$("#alerts").remove();

			$.scrollTo(0, 0);
	});
</script>