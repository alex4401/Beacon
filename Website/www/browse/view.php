<?php

if (empty($_GET['document_id'])) {
	header('Location: /browse/');
	exit;
}

require(dirname(__FILE__, 3) . '/framework/loader.php');

$document_id = $_GET['document_id'];
$search_keys = array(
	'public' => true,
	'document_id' => $document_id
);
	

$documents = BeaconDocument::Search($search_keys);
if (count($documents) != 1) {
	http_response_code(404);
	BeaconTemplate::SetTitle('Document Not Found');
	echo '<h1>Document not found</h1><p><a href="/browse/">Browse community documents</a></p>';
	exit;
}

$document = $documents[0];

$map_filter = $document->MapMask();
if (array_key_exists('map_filter', $_GET)) {
	$map_filter = intval($_GET['map_filter']);
}

BeaconTemplate::SetTitle($document->Name());
BeaconTemplate::AddStylesheet(BeaconCommon::AssetURI('generator.scss'));
BeaconTemplate::AddScript(BeaconCommon::AssetURI('generator.js'));

$author_id = $document->UserID();
$author = BeaconUser::GetByUserID($author_id);
$author_name = $author->IsAnonymous() ? 'Anonymous' : $author->Username();

?><h1><?php echo htmlentities($document->Name()); ?><br><span class="subtitle">By <?php echo htmlentities($author_name); ?><span class="user-suffix">#<?php echo htmlentities($author->Suffix()); ?></span></span></h1>
<h3>Description</h3>
<div class="indent">
	<p><?php echo nl2br(htmlentities($document->Description())); ?></p>
</div>
<h3>Requirements</h3>
<div class="indent">
	<p>Maps: <?php
$map_names = BeaconMaps::Names($document->MapMask());
if (count($map_names) >= 3) {
	$last = array_pop($map_names);
	echo implode(', ', $map_names) . ', and ' . $last;
	$map_names[] = $last;
} elseif (count($map_names) == 2) {
	echo $map_names[0] . ' and ' . $map_names[1];
} else {
	echo $map_names[0];
}
?></p>
	<p>Platforms: <span class="platform_tag pc">PC</span><?php if ($document->ConsoleSafe()) {?><span class="platform_tag xbox">Xbox</span><span class="platform_tag playstation">PlayStation</span><?php } ?></p>
	<?php
		
	$database = BeaconCommon::Database();
	$mod_ids = $document->RequiredMods(false);
	$results = $database->Query('SELECT workshop_id, name FROM mods WHERE array_position($1, mod_id) IS NOT NULL;', $mod_ids);
	$unknown_mods = false;
	$mod_links = array();
	while (!$results->EOF()) {
		$mod_links[] = '<a href="/mods/' . abs($results->Field('workshop_id')) . '">' . htmlentities($results->Field('name')) . '</a>';
		$results->MoveNext();
	}
	if (count($mod_links) != count($document->RequiredMods(true))) {
		$mod_links[] = 'one or more mods not listed with Beacon';
	}
	
	if (count($mod_links) > 0) {
		echo '<p>Uses Mods: ' . ucfirst(BeaconCommon::ArrayToEnglish($mod_links)) . '.</p>';
	}
	
	$editors = $document->ImplementedConfigs(true);
	$editor_names = array();
	foreach ($editors as $name) {
		switch ($name) {
		case 'LootDrops':
			$editor_names[] = 'Loot Drop Contents';
			break;
		case 'LootScale':
			$editor_names[] = 'Loot Quality Scaling';
			break;
		case 'ExperienceCurves':
			$editor_names[] = 'Player and Tame Levels';
			break;
		case 'CraftingCosts':
			$editor_names[] = 'Crafting Costs';
			break;
		case 'StackSizes':
			$editor_names[] = 'Stack Sizes';
			break;
		case 'BreedingMultipliers':
			$editor_names[] = 'Breeding Multipliers';
			break;
		case 'HarvestRates':
			$editor_names[] = 'Harvest Rates';
			break;
		case 'DinoAdjustments':
			$editor_names[] = 'Creature Adjustments';
			break;
		}
	}
	if (count($editor_names) > 0) {
		echo '<p>Contains Configs: ' . BeaconCommon::ArrayToEnglish($editor_names) . '</p>';
	}
		
	?>
</div>
<h3>Download</h3>
<div class="indent">
	<p><a href="<?php echo $document->ResourceURL(); ?>" rel="nofollow">Download original document</a> or <a href="<?php echo str_replace('https://', 'beacon://', $document->ResourceURL()); ?>" rel="nofollow">Open document in Beacon</a></p>
</div>
<h3>Create Game.ini</h3>
<div class="indent">
	<p>Create a customized Game.ini from this document.</p>
	<div id="mode_tabs"><div id="mode_tabs_new" class="selected">Create New</div><div id="mode_tabs_paste">Paste Text</div><div id="mode_tabs_upload">Upload File</div></div>
	<div id="mode_customizations">
		<input type="hidden" id="map_mask" name="map_mask" value="<?php echo ($map_filter & $document->MapMask()); ?>">
		<table id="options_table">
		<?php if (count($map_names) > 1) { ?><tr><td class="label">Include Maps:</td><td><?php
		
		foreach ($map_names as $name) {
			$value = BeaconMaps::ValueForName($name);
			$id = 'map_check_' . $value;
			echo ' <label class="checkbox"><input id="' . $id . '" type="checkbox" value="' . $value . '"' . (($map_filter & $value) == $value ? ' checked' : '') . '><span></span>' . htmlentities($name) . '</label>';
		}
		
		?></td></tr><?php } ?>
		<tr><td class="label"><label for="dino_level_field">Max Dino Level:</label></td><td><input type="number" id="dino_level_field" value="120"></td></tr>
		<tr><td class="label"><label for="difficulty_reference">Difficulty Settings:</label></td><td><textarea readonly rows="2" id="difficulty_reference"></textarea><br><span class="smaller">This space is only a reference. These options will produce the desired dino level. Loot will be scaled accordingly.</span></td></tr>
		</table>
	</div>
	<div id="mode_view">
		<div id="mode_view_new">
			<p>This option creates a new Game.ini from scratch. Use this if your server has no customizations.</p>
			<form action="generate.php" method="get">
				<input type="hidden" name="document_id" value="<?php echo htmlentities($document->DocumentID()); ?>">
				<input type="hidden" name="difficulty_value" value="" id="create_difficulty_value">
				<p class="text-center"><label class="radio"><input type="radio" name="mode" value="inline" id="create_inline_check" checked><span></span>Show new Game.ini in browser</label><br><label class="radio"><input type="radio" name="mode" value="download" id="create_download_check"><span></span>Download new Game.ini</label></p>
				<p class="text-center"><input type="submit" value="Generate"></p>
			</form>
		</div>
		<div id="mode_view_paste">
			<p>Paste your current Game.ini here and a customized version will be produced for you.</p>
			<form action="generate.php" method="post">
				<input type="hidden" name="document_id" value="<?php echo htmlentities($document->DocumentID()); ?>">
				<input type="hidden" name="mode" value="inline">
				<input type="hidden" name="difficulty_value" value="" id="paste_difficulty_value">
				<textarea name="content" rows="20" wrap="off"></textarea>
				<p class="text-center"><input type="submit" value="Generate"></p>
			</form>
		</div>
		<div id="mode_view_upload">
			<p>Upload your current Game.ini to download a customized version.</p>
			<form action="generate.php" method="post" enctype="multipart/form-data">
				<input type="hidden" name="document_id" value="<?php echo htmlentities($document->DocumentID()); ?>">
				<input type="hidden" name="mode" value="download">
				<input type="hidden" name="difficulty_value" value="" id="upload_difficulty_value">
				<input type="file" name="content" accept=".ini" id="upload_file_selector">
				<p class="text-center"><input type="submit" id="upload_file_selector_button" value="Choose File"></p>
			</form>
		</div>
	</div>
</div>