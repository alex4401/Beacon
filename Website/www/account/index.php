<?php
	
require(dirname(__FILE__, 3) . '/framework/loader.php');

$session = BeaconSession::GetFromCookie();
if (is_null($session)) {
	BeaconLogin::Present('Please log in to access your account.');
	exit;
}

header('Cache-Control: no-cache');

$user = BeaconUser::GetByUserID($session->UserID());
BeaconTemplate::SetTitle('Account: ' . $user->LoginKey());

BeaconTemplate::StartStyles(); ?>
<style>

#account_toolbar_menu {
	list-style: none;
	padding: 0px;
	display: flex;
	flex-direction: row;
	margin-left: auto;
	margin-right: auto;
	justify-content: center;
	border-color: inherit;
	flex-wrap: wrap;
	
	li {
		flex: 0 0 0px;
		text-align: center;
		
		border-color: inherit;
		white-space: nowrap;
		margin: 0px;
		
		a {
			text-decoration: none;
			padding: 0px;
			margin: 0px;
			display: block;
			border-radius: 6px;
			padding: 0.35em 0.45em;
			font-size: 1.2em;
			line-height: 1.0em;
		}
		
		&.active {
			font-weight: 500;
		}
	}
}

</style><?php
BeaconTemplate::FinishStyles();

BeaconTemplate::StartScript(); ?>
<script>
var switchViewFromFragment = function() {
	var fragment = window.location.hash.substr(1);
	if (fragment !== '') {
		switchView(fragment);
	} else {
		switchView('documents');
	}
}	

var currentView = 'documents';
var switchView = function(newView) {
	if (newView == currentView) {
		return;
	}
	
	document.getElementById('account_toolbar_menu_' + currentView).className = '';
	document.getElementById('account_toolbar_menu_' + newView).className = 'active';
	document.getElementById('account_view_' + currentView).className = 'hidden';
	document.getElementById('account_view_' + newView).className = '';
	currentView = newView;
	
	if (window.location.hash !== '#' + newView) {
		history.pushState({}, '', '#' + newView);
	}
};

document.addEventListener('DOMContentLoaded', function(event) {
	document.getElementById('toolbar_documents_button').addEventListener('click', function(event) {
		switchView('documents');
	});
	document.getElementById('toolbar_omni_button').addEventListener('click', function(event) {
		switchView('omni');
	});
	document.getElementById('toolbar_settings_button').addEventListener('click', function(event) {
		switchView('settings');
	});
	document.getElementById('toolbar_team_button').addEventListener('click', function(event) {
		switchView('team');
	});
	
	switchViewFromFragment();
});

window.addEventListener('popstate', function(ev) {
	switchViewFromFragment();
});

</script><?php
BeaconTemplate::FinishScript();

?><h1><?php echo htmlentities($user->LoginKey()); ?><span class="user-suffix">#<?php echo htmlentities($user->Suffix()); ?></span><br><span class="subtitle"><a href="/account/auth.php?return=<?php echo urlencode('/'); ?>" title="Sign Out">Sign Out</a></span></h1>
<ul id="account_toolbar_menu" class="separator-color">
	<li id="account_toolbar_menu_documents" class="active"><a href="#documents" id="toolbar_documents_button">Documents</a></li>
	<li id="account_toolbar_menu_omni"><a href="#omni" id="toolbar_omni_button">Omni</a></li>
	<li id="account_toolbar_menu_settings"><a href="#settings" id="toolbar_settings_button">Settings</a></li>
	<li id="account_toolbar_menu_team"><a href="#team" id="toolbar_team_button">Team Members</a></li>
</ul>
<div id="account_views">
	<div id="account_view_documents"><?php include('includes/documents.php'); ?></div>
	<div id="account_view_omni" class="hidden"><?php include('includes/omni.php'); ?></div>
	<div id="account_view_settings" class="hidden"><?php include('includes/settings.php'); ?></div>
	<div id="account_view_team" class="hidden"><?php include('includes/children.php'); ?></div>
</div>