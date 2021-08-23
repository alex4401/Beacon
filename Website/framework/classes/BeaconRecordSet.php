<?php

abstract class BeaconRecordSet implements Iterator {
	abstract public function __construct($result);
	abstract public function RecordCount();
	abstract public function MoveTo(int $offset);
	abstract public function BOF();
	abstract public function EOF();
	abstract public function MoveFirst();
	abstract public function MovePrevious();
	abstract public function MoveNext();
	abstract public function MoveLast();
	abstract public function Field($columnOrIndex);
	abstract public function FieldCount();
	abstract public function FieldName(int $index);
	abstract public function IndexOf(string $column);
	
	public function AsArray() {
		$bound = $this->FieldCount();
		$row = [];
		for ($idx = 0; $idx < $bound; $idx++) {
			$field = $this->FieldName($idx);
			$value = $this->Field($idx);
			$row[$field] = $value;
		}
		return $row;
	}
}

?>