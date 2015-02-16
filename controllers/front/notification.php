<?php

include_once dirname(__FILE__).'/../../../../config/config.inc.php';
include_once dirname(__FILE__).'/../../../../init.php';
include_once(dirname(__FILE__).'/../../mercadopago.php');

$mercadopago = new MercadoPago();
$mercadopago->updateOrder(Tools::getValue('topic'), Tools::getValue('id'));
?>