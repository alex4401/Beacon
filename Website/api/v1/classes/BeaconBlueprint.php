<?php

class BeaconBlueprint extends BeaconObject {
	private $availability;
	private $path;
	private $class_string;
	private $is_ambiguous = false;
	
	protected static function SQLColumns() {
		$columns = parent::SQLColumns();
		$columns[] = 'availability';
		$columns[] = 'path';
		$columns[] = 'class_string';
		$columns[] = '(SELECT COUNT(object_id) FROM ' . static::TableName() . ' AS x WHERE x.class_string = ' . static::TableName() . '.class_string) AS duplicate_count';
		return $columns;
	}
	
	protected static function TableName() {
		return 'blueprints';
	}
	
	protected function GetColumnValue(string $column) {
		switch ($column) {
		case 'availability':
			return $this->availability;
		case 'path':
			return $this->path;
		case 'class_string':
			return $this->class_string;
		default:
			return parent::GetColumnValue($column);
		}
	}
	
	public function ConsumeJSON(array $json) {
		parent::ConsumeJSON($json);
		
		if (array_key_exists('path', $json)) {
			$this->path = $json['path'];
		}
		if (array_key_exists('availability', $json) && is_int($json['availability'])) {
			$this->availability = intval($json['availability']);
		} else {
			if (array_key_exists('environments', $json)) {
				$environments = $json['environments'];
			} elseif (array_key_exists('availability', $json)) {
				$environments = $json['availability'];
			}
			if (isset($environments)) {
				if (is_array($environments) === false) {
					throw new Exception('Must supply map availability as an array or integer');
				}
				$availability = 0;
				foreach ($environments as $environment) {
					$environment = strtolower(trim($environment));
					if ($environment === 'island') {
						$availability = $availability | BeaconMaps::TheIsland;
					}
					if ($environment === 'scorched') {
						$availability = $availability | BeaconMaps::ScorchedEarth;
					}
					if ($environment === 'center') {
						$availability = $availability | BeaconMaps::TheCenter;
					}
					if ($environment === 'ragnarok') {
						$availability = $availability | BeaconMaps::Ragnarok;
					}
					if (($environment === 'abberation') || ($environment === 'aberration')) {
						$availability = $availability | BeaconMaps::Aberration;
					}
					if ($environment === 'extinction') {
						$availability = $availability | BeaconMaps::Extinction;
					}
					if ($environment === 'valguero') {
						$availability = $availability | BeaconMaps::Valguero;
					}
					if ($environment === 'genesis') {
						$availability = $availability | BeaconMaps::Genesis;
					}
				}
				$this->availability = $availability;
			}
		}
	}
	
	protected static function FromRow(BeaconRecordSet $row) {
		$obj = parent::FromRow($row);
		if ($obj === null) {
			return null;
		}
		$obj->availability = intval($row->Field('availability'));
		$obj->path = $row->Field('path');
		$obj->class_string = $row->Field('class_string');
		$obj->is_ambiguous = intval($row->Field('duplicate_count')) > 1;
		return $obj;
	}
	
	protected static function ListValueToParameter($value, array &$possible_columns) {
		if (is_string($value)) {
			if (strtoupper(substr($value, -2)) == '_C') {
				$possible_columns[] = 'class_string';
				return $value;
			} elseif (preg_match('/^[A-F0-9]{32}$/i', $value)) {
				$possible_columns[] = 'MD5(LOWER(path))';
				return $value;
			} elseif (strtolower(substr($value, 0, 6)) == '/game/') {
				$possible_columns[] = 'path';
				return $value;
			}
		}
		
		return parent::ListValueToParameter($value, $possible_columns);
	}
	
	public function jsonSerialize() {
		$environments = array();
		if ($this->AvailableToIsland()) {
			$environments[] = 'Island';
		}
		if ($this->AvailableToScorched()) {
			$environments[] = 'Scorched';
		}
		if ($this->AvailableToCenter()) {
			$environments[] = 'Center';
		}
		if ($this->AvailableToRagnarok()) {
			$environments[] = 'Ragnarok';
		}
		if ($this->AvailableToAberration()) {
			$environments[] = 'Aberration';
		}
		if ($this->AvailableToExtinction()) {
			$environments[] = 'Extinction';
		}
		if ($this->AvailableToValguero()) {
			$environments[] = 'Valguero';
		}
		if ($this->AvailableToGenesis()) {
			$environments[] = 'Genesis';
		}
		
		$json = parent::jsonSerialize();
		$json['availability'] = intval($this->availability);
		$json['environments'] = $environments;
		$json['path'] = $this->path;
		$json['class_string'] = $this->class_string;
		$json['spawn'] = $this->SpawnCode();
		
		return $json;
	}
	
	public function Path() {
		return $this->path;
	}
	
	public function Hash() {
		return md5(strtolower($this->path));
	}
	
	public function SetPath(string $path) {
		$this->path = $path;
		$this->class_string = self::ClassFromPath($path);
	}
	
	public function ClassString() {
		return $this->class_string;
	}
	
	public function IsAmbiguous() {
		return $this->is_ambiguous;
	}
	
	public function Availability() {
		return $this->availability;
	}
	
	public function SetAvailability(int $availability) {
		$this->availability = $availability;
	}
	
	public function AvailableTo(int $mask) {
		return ($this->availability & $mask) !== 0;
	}
	
	public function SetAvailableTo(int $mask, bool $available) {
		if ($available) {
			$this->availability = $this->availability | $mask;
		} else {
			$this->availability = $this->availability & ~$mask;
		}
	}
	
	public function AvailableToIsland() {
		return $this->AvailableTo(BeaconMaps::TheIsland);
	}
	
	public function SetAvailableToIsland(bool $available) {
		return $this->SetAvailableTo(BeaconMaps::TheIsland, $available);
	}
	
	public function AvailableToScorched() {
		return $this->AvailableTo(BeaconMaps::ScorchedEarth);
	}
	
	public function SetAvailableToScorched(bool $available) {
		return $this->SetAvailableTo(BeaconMaps::ScorchedEarth, $available);
	}
	
	public function AvailableToCenter() {
		return $this->AvailableTo(BeaconMaps::TheCenter);
	}
	
	public function SetAvailableToCenter(bool $available) {
		return $this->SetAvailableTo(BeaconMaps::TheCenter, $available);
	}
	
	public function AvailableToRagnarok() {
		return $this->AvailableTo(BeaconMaps::Ragnarok);
	}
	
	public function SetAvailableToRagnarok(bool $available) {
		return $this->SetAvailableTo(BeaconMaps::Ragnarok, $available);
	}
	
	public function AvailableToAberration() {
		return $this->AvailableTo(BeaconMaps::Aberration);
	}
	
	public function SetAvailableToAberration(bool $available) {
		return $this->SetAvailableTo(BeaconMaps::Aberration, $available);
	}
	
	public function AvailableToExtinction() {
		return $this->AvailableTo(BeaconMaps::Extinction);
	}
	
	public function SetAvailableToExtinction(bool $available) {
		return $this->SetAvailableTo(BeaconMaps::Extinction, $available);
	}
	
	public function AvailableToValguero() {
		return $this->AvailableTo(BeaconMaps::Valguero);
	}
	
	public function SetAvailableToValguero(bool $available) {
		return $this->SetAvailableTo(BeaconMaps::Valguero, $available);
	}
	
	public function AvailableToGenesis() {
		return $this->AvailableTo(BeaconMaps::Genesis);
	}
	
	public function SetAvailableToGenesis(bool $available) {
		return $this->SetAvailableTo(BeaconMaps::Genesis, $available);
	}
	
	public function SpawnCode() {
		return 'cheat summon ' . $this->ClassString();
	}
	
	protected static function ClassFromPath(string $path) {
		$components = explode('/', $path);
		$tail = array_pop($components);
		$components = explode('.', $tail);
		$class = array_pop($components);
		return $class . '_C';
	}
	
	public function RelatedObjectIDs() {
		return array();
	}
}

?>
