#tag Class
Protected Class MutableLootContainer
Inherits Ark.LootContainer
Implements Ark.MutableBlueprint
	#tag Method, Flags = &h0
		Sub Add(ItemSet As Ark.LootItemSet)
		  Var Idx As Integer = Self.IndexOf(ItemSet)
		  If Idx = -1 Then
		    Self.mItemSets.Add(ItemSet.ImmutableVersion)
		    Self.Modified = True
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AlternateLabel(Assigns Value As NullableString)
		  // Part of the Ark.MutableBlueprint interface.
		  
		  Self.mAlternateLabel = Value
		  Self.Modified = True
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AppendMode(Assigns Value As Boolean)
		  Self.mAppendMode = Value
		  Self.Modified = True
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Availability(Assigns Value As UInt64)
		  // Part of the Ark.MutableBlueprint interface.
		  
		  Self.mAvailability = Value
		  Self.Modified = True
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor()
		  Super.Constructor
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Experimental(Assigns Value As Boolean)
		  Self.mExperimental = Value
		  Self.Modified = True
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ImmutableVersion() As Ark.LootContainer
		  Return New Ark.LootContainer(Self)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub IsTagged(Tag As String, Assigns Value As Boolean)
		  // Part of the Ark.MutableBlueprint interface.
		  
		  Tag = Beacon.NormalizeTag(Tag)
		  Var Idx As Integer = Self.mTags.IndexOf(Tag)
		  If Idx > -1 And Value = False Then
		    Self.mTags.RemoveAt(Idx)
		    Self.Modified = True
		  ElseIf Idx = -1 And Value = True Then
		    Self.mTags.Add(Tag)
		    Self.mTags.Sort()
		    Self.Modified = True
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Label(Assigns Value As String)
		  // Part of the Ark.MutableBlueprint interface.
		  
		  Self.mLabel = Value
		  Self.Modified = True
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MaxItemSets(Assigns Value As Integer)
		  Self.mMaxItemSets = Max(Value, 0)
		  Self.Modified = True
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MinItemSets(Assigns Value As Integer)
		  Self.mMinItemSets = Max(Value, 0)
		  Self.Modified = True
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ModID(Assigns Value As String)
		  // Part of the Ark.MutableBlueprint interface.
		  
		  Self.mModID = Value
		  Self.Modified = True
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ModName(Assigns Value As String)
		  // Part of the Ark.MutableBlueprint interface.
		  
		  Self.mModName = Value
		  Self.Modified = True
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Multipliers(Assigns Value As Beacon.Range)
		  Self.mMultipliers = Value
		  Self.Modified = True
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function MutableVersion() As Ark.MutableLootContainer
		  Return Self
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Notes(Assigns Value As String)
		  Self.mNotes = Value
		  Self.Modified = True
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Operator_Subscript(Idx As Integer, Assigns ItemSet As Ark.LootItemSet)
		  Self.mItemSets(Idx) = ItemSet.ImmutableVersion
		  Self.Modified = True
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Path(Assigns Value As String)
		  // Part of the Ark.MutableBlueprint interface.
		  
		  Self.mPath = Value
		  Self.mClassString = Beacon.ClassStringFromPath(Value)
		  Self.Modified = True
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub PreventDuplicates(Assigns Value As Boolean)
		  Self.mPreventDuplicates = Value
		  Self.Modified = True
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Remove(ItemSet As Ark.LootItemSet)
		  Var Idx As Integer = Self.IndexOf(ItemSet)
		  If Idx > -1 Then
		    Self.RemoveAt(Idx)
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RemoveAt(Idx As Integer)
		  Self.mItemSets.RemoveAt(Idx)
		  Self.Modified = True
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RequiredItemSetCount(Assigns Value As Integer)
		  Self.mRequiredItemSetCount = Value
		  Self.Modified = True
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SortValue(Assigns Value As Integer)
		  Self.mSortValue = Value
		  Self.Modified = True
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Tags(Assigns Tags() As String)
		  // Part of the Ark.MutableBlueprint interface.
		  
		  Self.mTags.ResizeTo(-1)
		  For Each Tag As String In Tags
		    Tag = Beacon.NormalizeTag(Tag)
		    Self.mTags.Add(Tag)
		  Next
		  Self.mTags.Sort
		  Self.Modified = True
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UIColor(Assigns Value As Color)
		  Self.mUIColor = Value
		  Self.Modified = True
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Unpack(Dict As Dictionary)
		  // Part of the Ark.MutableBlueprint interface.
		  
		  
		End Sub
	#tag EndMethod


End Class
#tag EndClass