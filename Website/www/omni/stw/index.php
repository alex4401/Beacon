<?php

require(dirname(__FILE__, 4) . '/framework/loader.php');
BeaconTemplate::SetTitle('The \'Share The Wealth\' Program');

$utc = new DateTime(date('Y-m-d 13:00', time()));
$est = clone $utc;
$est->setTimezone(new DateTimeZone('America/New_York'));
$pst = clone $utc;
$pst->setTimezone(new DateTimeZone('America/Los_Angeles'));

BeaconCommon::StartSession();
if (isset($_SESSION['STW_PUBLIC_KEY'])) {
	$public_key = $_SESSION['STW_PUBLIC_KEY'];
} else {
	BeaconEncryption::GenerateKeyPair($public_key, $private_key);
	$_SESSION['STW_PRIVATE_KEY'] = $private_key;
	$_SESSION['STW_PUBLIC_KEY'] = $public_key;
	unset($private_key);
}

$database = BeaconCommon::Database();
$results = $database->Query('SELECT product_id FROM products WHERE product_id = $1;', BeaconShop::ARK2_PRODUCT_ID);
$ark2_enabled = $results->RecordCount() === 1;

BeaconTemplate::AddScript('https://cdnjs.cloudflare.com/ajax/libs/jsencrypt/2.3.1/jsencrypt.min.js');

BeaconTemplate::StartScript(); ?>
<script>

document.addEventListener('DOMContentLoaded', function() {
	document.getElementById('stw_form').addEventListener('submit', function(ev) {
		var encrypt = new JSEncrypt();
		encrypt.setPublicKey(<?php echo json_encode($public_key); ?>);
		
		var encrypted = encrypt.encrypt(document.getElementById('stw_email_field').value);
		var join_button = document.getElementById('stw_join_button');
		join_button.disabled = true;
		
		var product_id = document.getElementById('ark_radio').value;
		<?php if ($ark2_enabled) { ?>if (document.getElementById('ark2_radio').checked) {
			product_id = document.getElementById('ark2_radio').value;
		}<?php } ?>
		
		var fields = {'email': encrypted, 'product_id': product_id};
		request.post('submit', fields, function (obj) {
			var container = document.getElementById('stw_container');
			container.innerHTML = 'Ok, ' + obj.email + ' is now on the list! If selected, you will receive an email with instructions.';
		}, function (http_status, response_body) {
			switch (http_status) {
			case 404:
				dialog.show('Unable to submit the email address', 'The receiver script was not found.');
				break;
			case 400:
				var obj = JSON.parse(response_body);
				dialog.show('Sorry, that didn\'t work.', obj.error);
				break;
			default:
				dialog.show('Unable to submit the email address', 'Sorry, there was a ' + http_status + ' error: ' + response_body);
				break;
			}
			join_button.disabled = false;
		});
		
		ev.preventDefault();
		return true;
	});
});

</script>
<?php
BeaconTemplate::FinishScript();

?><h1>Beacon's <em>Share The Wealth</em> Program</h1>
<p>Beacon's <em>Share The Wealth</em> program is an option for users who want to show additional support for Beacon, while also providing licenses to other users.</p>
<h3>How to give a copy of Beacon Omni</h3>
<p>When purchasing, the line labeled &quot;Beacon Share The Wealth&quot; allows purchasing up to 10 additional copies of Beacon Omni to be given away to random users.</p>
<h3>How to get a free copy of Beacon Omni</h3>
<p>If you'd like to be a potential recipient of a free Beacon Omni license under the <em>Share The Wealth</em> program, all you need to do is add your email address.</p>
<div id="stw_container" class="text-center inset-note">
	<form action="#" method="post" id="stw_form">
		<?php if ($ark2_enabled) { ?>
		<p class="bold">Product</p>
		<ul class="no-markings">
			<li><label for="ark2_radio" class="radio"><input type="radio" name="product_id" value="<?php echo BeaconShop::ARK2_PRODUCT_ID; ?>" id="ark2_radio" checked><span></span>Beacon Omni for Ark 2</label></li>
			<li><label for="ark_radio" class="radio"><input type="radio" name="product_id" value="<?php echo BeaconShop::ARK_PRODUCT_ID; ?>" id="ark_radio"><span></span>Beacon Omni for Ark: Survival Evolved</label></li>
		</ul>
		<?php } ?><p><?php if ($ark2_enabled === false) { ?><input type="hidden" name="product_id" value="<?php echo htmlentities(BeaconShop::ARK_PRODUCT_ID); ?>" id="ark_radio"><?php } ?><input type="email" placeholder="E-Mail Address" id="stw_email_field" name="email"></p>
		<p><input type="submit" value="Join the Program" id="stw_join_button"></p>
	</form>
</div>
<p class="smaller">There's no guarantee when or if your address will be chosen at random. Odds of selection depend on number of participants and purchasers. One recipient will be chosen each day at <?php echo $utc->format('g:i A T'); ?> / <?php echo $est->format('g:i A T'); ?> / <?php echo $pst->format('g:i A T'); ?>, as long as there are Beacon Omni licenses waiting in the <em>Share The Wealth</em> program. Participants will be removed from the list after six months.</p>
<p class="smaller">Because Beacon is so interested in privacy, email addresses are normally stored as a one-way hash. However, the <em>Share The Wealth</em> program requires email addresses to be accessible to send out notifications to recipients. Therefore, email addresses entered into the <em>Share The Wealth</em> program will be stored using encryption instead of hashing. If selected, the encrypted email address will be discarded and converted to a high security hashed value.</p>