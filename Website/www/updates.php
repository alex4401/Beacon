<?php

require(dirname(__FILE__, 2) . '/framework/loader.php');
header('Cache-Control: no-cache');

$stage = 3;
$current_build = 0;
$portable = false;
$match_architecture = null;
$platform = null;
$arch_points = [
	'x86' => 1,
	'x64' => 1, 
	'arm' => 1,
	'arm64' => 1
];
if (isset($_GET['build'])) {
	$current_build = intval($_GET['build']);
	$stage = floor($current_build / 100) % 10;
} elseif (isset($_GET['stage'])) {
	$stage = intval($_GET['stage']);
}
if (isset($_GET['html'])) {
	$html_mode = true;
	header('Content-Type: text/html');
} else {
	$html_mode = false;
	header('Content-Type: application/json');
}
if (isset($_GET['portable'])) {
	$portable = strtolower($_GET['portable']) === 'true';
}
// Beacon 1.2.0 and its betas did not report architecture correctly
if ($current_build >= 10201300 && isset($_GET['arch'])) {
	switch ($_GET['arch']) {
	case 'x86_64':
	case 'x64':
		$match_architecture = 'x64';
		$arch_points['x64'] = 2;
		$arch_points['x86'] = 1;
		$arch_points['arm64'] = 0;
		$arch_points['arm'] = 0;
		break;
	case 'x86':
		$match_architecture = 'x86';
		$arch_points['x64'] = 0;
		$arch_points['x86'] = 1;
		$arch_points['arm64'] = 0;
		$arch_points['arm'] = 0;
		break;
	case 'arm_64':
	case 'arm64':
		$match_architecture = 'arm64';
		$arch_points['x64'] = 1;
		$arch_points['x86'] = 2;
		$arch_points['arm64'] = 4;
		$arch_points['arm'] = 3;
		break;
	case 'arm':
		$match_architecture = 'arm';
		$arch_points['x64'] = 0;
		$arch_points['x86'] = 1;
		$arch_points['arm64'] = 0;
		$arch_points['arm'] = 2;
		break;
	}
}
if (isset($_GET['platform'])) {
	$platform = strtolower($_GET['platform']);
	switch ($platform) {
	case 'mac':
		$platform = 'macOS';
		break;
	case 'win':
		$platform = 'Windows';
		break;
	case 'lin':
		$platform = 'Linux';
		break;
	default:
		$platform = null;
		break;
	}
}
if (is_null($platform) === false && isset($_GET['osversion']) && preg_match('/^\d{1,3}\.\d{1,3}\.\d{1,6}$/', $_GET['osversion']) === 1) {
	switch ($platform) {
	case 'macOS':
		$version_column = 'min_mac_version';
		$os_version = $_GET['osversion'];
		break;
	case 'Windows':
		$version_column = 'min_win_version';
		$os_version = $_GET['osversion'];
		break;
	}
}

$include_notices = $current_build > 33 && $current_build < 10500000;

$database = BeaconCommon::Database();
if ($include_notices) {
	$notices = array();
	if ($html_mode === false) {
		$results = $database->Query('SELECT message, secondary_message, action_url FROM client_notices WHERE (min_version IS NULL OR min_version <= $1) AND (max_version IS NULL OR max_version >= $1) AND last_update > CURRENT_TIMESTAMP - \'3 weeks\'::INTERVAL ORDER BY last_update DESC LIMIT 5;', $current_build);
		while (!$results->EOF()) {
			$notices[] = array(
				'message' => $results->Field('message'),
				'secondary_message' => $results->Field('secondary_message'),
				'action_url' => $results->Field('action_url')
			);
			$results->MoveNext();
		}
	}
}

$values = [$current_build, $stage];
$update_sql = 'SELECT * FROM updates WHERE build_number > $1 AND stage >= $2';
$is_required_sql = 'SELECT COUNT(update_id) AS num_required_updates FROM updates WHERE build_number >= $1 AND stage >= $2 AND $1 <@ lock_versions';
if (isset($version_column) && isset($os_version)) {
	$os_version_sql = ' AND os_version_as_integer(' . $version_column . ') <= os_version_as_integer($3)';
	$update_sql .= $os_version_sql;
	$is_required_sql .= $os_version_sql;
	$values[] = $os_version;
}
$update_sql .= ' ORDER BY build_number DESC';
if ($current_build === 0) {
	$update_sql .= ' LIMIT 1';
}
$update_sql .= ';';

$update_results = $database->Query($update_sql, $values);
if ($update_results->RecordCount() === 0) {
	if ($html_mode) {
		echo '<!DOCTYPE html><html><head><meta charset="UTF-8"><title>Beacon Update</title></head><body><h1>No update</h1></body></html>';
	} elseif ($include_notices) {
		$values = array(
			'notices' => $notices
		);
		echo json_encode($values, JSON_PRETTY_PRINT);
	} else {
		echo '{}';
	}
	exit;
}
$is_required = $database->Query($is_required_sql, $values)->Field('num_required_updates') > 0;
$update_id = $update_results->Field('update_id');

if (is_null($platform) === false) {
	$download_results = $database->Query('SELECT platform, TRIM(\'{}\' FROM architectures::TEXT) AS architectures, url, portable, signature FROM update_downloads WHERE update_id = $1 AND platform = $2;', $update_id, $platform);
} else {
	$download_results = $database->Query('SELECT platform, TRIM(\'{}\' FROM architectures::TEXT) AS architectures, url, portable, signature FROM update_downloads WHERE update_id = $1;', $update_id);
}
$scores = [
	'macOS' => [
		'score' => 0,
		'download' => null
	],
	'Windows' => [
		'score' => 0,
		'download' => null
	],
	'Linux' => [
		'score' => 0,
		'download' => null
	]
];
foreach ($download_results as $download) {
	$score = 0;
	$architectures = explode(',', $download['architectures']);
	if (count($architectures) === 1 && $architectures[0] === $match_architecture) {
		// Perfect match
		$score += 100;
	} else {
		foreach ($architectures as $arch) {
			$score += $arch_points[$arch];
		}
	}
	if ($score === 0) {
		// This version has no compatibility at all
		continue;
	}
	if ($portable == $download['portable']) {
		$score += 1;
	}
	
	if ($score > $scores[$download['platform']]['score']) {
		$scores[$download['platform']]['score'] = $score;
		$scores[$download['platform']]['download'] = [
			'url' => $download['url'],
			'signature' => $download['signature'],
			'architectures' => $architectures,
			'portable' => $download['portable']
		];
	}
}

$notes_path = '/history';
if ($update_results->Field('stage') < 3) {
	// It may seem odd, but preview releases should show notes for both alphas and betas.
	$notes_path .= '?stage=1';
}
$notes_path .= '#build' . $update_results->Field('build_number');

$values = [
	'build' => intval($update_results->Field('build_number')),
	'version' => $update_results->Field('build_display'),
	'preview' => ($current_build < 10500000) ? 'Beacon\'s biggest update ever is here!' : $update_results->Field('preview'),
	'notes' => '',
	'notes_url' => BeaconCommon::AbsoluteURL($notes_path),
	'required' => $is_required
];

if (is_null($scores['macOS']['download']) === false) {
	$download = $scores['macOS']['download'];
	$values['mac'] = [
		'url' => BeaconCommon::SignDownloadURL($download['url']),
		'signature' => $download['signature']
	];
}
if (is_null($scores['Windows']['download']) === false) {
	$download = $scores['Windows']['download'];
	$values['win'] = [
		'url' => BeaconCommon::SignDownloadURL($download['url']),
		'signature' => $download['signature']
	];
}
if (is_null($scores['Linux']['download']) === false) {
	$download = $scores['Linux']['download'];
	$values['lin'] = [
		'url' => BeaconCommon::SignDownloadURL($download['url']),
		'signature' => $download['signature']
	];
}

if ($include_notices) {
	$values['notices'] = $notices;
}

$markdown = '';
while (!$update_results->EOF()) {
	if ($markdown === '') {
		$markdown = "# Beacon " . $update_results->Field('build_display') . " is now available\n\n" . $update_results->Field('notes');
	} else {
		$markdown .= "\n\n## Changes in " . $update_results->Field('build_display') . "\n\n" . $update_results->Field('notes');
	}
	$update_results->MoveNext();
}

$parser = new Parsedown();
$body = $parser->text($markdown);

$css_url = BeaconCommon::AbsoluteURL(BeaconCommon::AssetURI('default.scss'));
$html = <<<HTML
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Beacon Update</title>
		<link href="$css_url" rel="stylesheet" type="text/css">
		<style type="text/css">
		body {margin: 20px;}
		</style>
	</head>
	<body>
$body
	</body>
</html>
HTML;

if ($html_mode) {
	echo $html;
} else {
	$values['notes'] = $html;
	$values['notes_url'] = BeaconCommon::AbsoluteURL($notes_path);
	echo json_encode($values, JSON_PRETTY_PRINT);
}

?>
