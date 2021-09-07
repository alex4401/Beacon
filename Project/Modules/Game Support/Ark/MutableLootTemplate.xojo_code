#tag Class
Protected Class MutableLootTemplate
Inherits Ark.LootTemplate
	#tag Method, Flags = &h0
		Sub Add(Entry As Ark.LootTemplateEntry)
		  Self.mEntries.Add(Entry.ImmutableVersion)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub BlueprintChanceMultiplier(LootSelector As Ark.LootContainerSelector, Assigns Value As Double)
		  Self.BlueprintChanceMultiplier(LootSelector.UUID) = Value
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub BlueprintChanceMultiplier(LootSelectorUUID As String, Assigns Value As Double)
		  If Self.mModifierValues Is Nil Then
		    Self.mModifierValues = New Dictionary
		  End If
		  
		  Var Dict As Dictionary = Self.mModifierValues.Lookup(LootSelectorUUID, New Dictionary)
		  Dict.Value("Blueprint Chance Multiplier") = Value
		  Self.mModifierValues.Value(LootSelectorUUID) = Dict
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Grouping(Assigns Value As String)
		  Self.mGrouping = Value
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ImmutableVersion() As Ark.LootTemplate
		  Return New Ark.LootTemplate(Self)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MaxEntriesSelected(Assigns Value As Integer)
		  Self.mMaxEntriesSelected = Value
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MaxQualityOffset(LootSelector As Ark.LootContainerSelector, Assigns Value As Integer)
		  Self.MaxQualityOffset(LootSelector.UUID) = Value
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MaxQualityOffset(LootSelectorUUID As String, Assigns Value As Integer)
		  If Self.mModifierValues Is Nil Then
		    Self.mModifierValues = New Dictionary
		  End If
		  
		  Var Dict As Dictionary = Self.mModifierValues.Lookup(LootSelectorUUID, New Dictionary)
		  Dict.Value("Max Quality Offset") = Value
		  Self.mModifierValues.Value(LootSelectorUUID) = Dict
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MinEntriesSelected(Assigns Value As Integer)
		  Self.mMinEntriesSelected = Value
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MinQualityOffset(LootSelector As Ark.LootContainerSelector, Assigns Value As Integer)
		  Self.MinQualityOffset(LootSelector.UUID) = Value
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MinQualityOffset(LootSelectorUUID As String, Assigns Value As Integer)
		  If Self.mModifierValues Is Nil Then
		    Self.mModifierValues = New Dictionary
		  End If
		  
		  Var Dict As Dictionary = Self.mModifierValues.Lookup(LootSelectorUUID, New Dictionary)
		  Dict.Value("Min Quality Offset") = Value
		  Self.mModifierValues.Value(LootSelectorUUID) = Dict
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function MutableVersion() As Ark.MutableLootTemplate
		  Return Self
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Operator_Subscript(Idx As Integer, Assigns Value As Ark.LootTemplateEntry)
		  Self.mEntries(Idx) = Value.ImmutableVersion
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub QuantityMultiplier(LootSelector As Ark.LootContainerSelector, Assigns Value As Double)
		  Self.QuantityMultiplier(LootSelector.UUID) = Value
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub QuantityMultiplier(LootSelectorUUID As String, Assigns Value As Double)
		  If Self.mModifierValues Is Nil Then
		    Self.mModifierValues = New Dictionary
		  End If
		  
		  Var Dict As Dictionary = Self.mModifierValues.Lookup(LootSelectorUUID, New Dictionary)
		  Dict.Value("Quantity Multiplier") = Value
		  Self.mModifierValues.Value(LootSelectorUUID) = Dict
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Remove(Entry As Ark.LootTemplateEntry)
		  Var Idx As Integer = Self.IndexOf(Entry)
		  If Idx > -1 Then
		    Self.RemoveAt(Idx)
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RemoveAt(Idx As Integer)
		  Self.mEntries.RemoveAt(Idx)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ResizeTo(UpperBound As Integer)
		  Self.mEntries.ResizeTo(UpperBound)
		End Sub
	#tag EndMethod


End Class
#tag EndClass
