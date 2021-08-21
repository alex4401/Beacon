#tag Class
Protected Class Preset
Implements Beacon.Countable
	#tag Method, Flags = &h0
		Function ActiveModifierIDs() As String()
		  Var IDs() As String
		  For Each Entry As DictionaryEntry In Self.mModifierValues
		    IDs.Add(Entry.Key)
		  Next
		  Return IDs
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function BlueprintMultiplier(Modifier As Beacon.PresetModifier) As Double
		  Return Self.BlueprintMultiplier(Modifier.ModifierID)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function BlueprintMultiplier(ModifierID As String) As Double
		  If Self.mModifierValues = Nil Then
		    Return 1.0
		  End If
		  
		  Var Dict As Dictionary = Self.mModifierValues.Lookup(ModifierID, New Dictionary)
		  Return Dict.Lookup("Blueprint", 1.0)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor()
		  Self.mLabel = "Untitled Preset"
		  Self.mGrouping = "Miscellaneous"
		  Self.mMinItems = 1
		  Self.mMaxItems = 3
		  Self.mPresetID = New v4UUID
		  Self.Type = Types.Custom
		  Self.mModifierValues = New Dictionary
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(Source As Beacon.Preset)
		  Self.mLabel = Source.mLabel
		  Self.mGrouping = Source.mGrouping
		  Self.mMinItems = Source.mMinItems
		  Self.mMaxItems = Source.mMaxItems
		  Self.mPresetID = Source.mPresetID
		  Self.Type = Source.Type
		  
		  Self.mModifierValues = New Dictionary
		  For Each Entry As DictionaryEntry In Source.mModifierValues
		    Var Dict As Dictionary = Entry.Value
		    Self.mModifierValues.Value(Entry.Key) = Dict.Clone
		  Next
		  
		  Self.mContents.ResizeTo(Source.mContents.LastIndex)
		  For I As Integer = 0 To Self.mContents.LastIndex
		    Self.mContents(I) = New Beacon.PresetEntry(Source.mContents(I))
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Count() As Integer
		  Return Self.mContents.LastIndex + 1
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Entry(Index As Integer) As Beacon.PresetEntry
		  Return New Beacon.PresetEntry(Self.mContents(Index))
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function FromDictionary(Dict As Dictionary) As Beacon.Preset
		  Var Version, MinVersion As Integer
		  If Dict.HasKey("Version") Then
		    Version = Dict.Value("Version")
		  End If
		  If Dict.HasKey("MinVersion") Then
		    MinVersion = Dict.Value("MinVersion")
		  Else
		    MinVersion = 2
		  End If
		  If MinVersion < 2 Or MinVersion > Beacon.Preset.Version Then
		    Return Nil
		  End If
		  
		  Var Preset As New Beacon.Preset
		  If Dict.HasKey("ID") Then
		    // Don't use lookup here to prevent creating the UUID unless necessary
		    Preset.mPresetID = Dict.Value("ID")
		  End If
		  If Preset.mPresetID = "" Then
		    Preset.mPresetID = New v4UUID
		  End If
		  Preset.mLabel = Dict.Lookup("Label", Preset.Label)
		  Preset.mGrouping = Dict.Lookup("Grouping", Preset.Grouping)
		  Preset.mMinItems = Dict.Lookup("Min", Preset.MinItems)
		  Preset.mMaxItems = Dict.Lookup("Max", Preset.MaxItems)
		  
		  // Beacon.PresetEntry.FromSaveData can understand both formats, the different
		  // keys are just for compatibility
		  Var Contents() As Variant
		  If Version >= 3 Then
		    If Dict.HasKey("ItemSets") = False Then
		      Return Nil
		    End If
		    
		    Contents = Dict.Value("ItemSets")
		  ElseIf Version >= 2 Then
		    If Dict.HasKey("Entries") = False Then
		      Return Nil
		    End If
		    
		    Contents = Dict.Value("Entries")
		  Else
		    Return Nil
		  End If
		  For Each EntryDict As Dictionary In Contents
		    Var Entry As Beacon.PresetEntry = Beacon.PresetEntry.FromSaveData(EntryDict)
		    If Entry <> Nil Then
		      Preset.mContents.Add(Entry)
		    End If
		  Next
		  
		  If Dict.HasKey("Modifiers") Then
		    Var Modifiers As Dictionary = Dict.Value("Modifiers")
		    For Each Set As DictionaryEntry In Modifiers
		      Var Item As Dictionary = Set.Value
		      Var ModifierID As String = Set.Key
		      Var MinQuality As Integer = If(Item.HasKey("MinQuality"), Item.Value("MinQuality"), Item.Lookup("Quality", 0))
		      Var MaxQuality As Integer = If(Item.HasKey("MaxQuality"), Item.Value("MaxQuality"), Item.Lookup("Quality", 0))
		      Var Quantity As Double = Item.Lookup("Quantity", 1.0)
		      Var Blueprint As Double = Item.Lookup("Blueprint", 1.0)
		      
		      If MinQuality = 0 And MaxQuality = 0 And Quantity = 1 And Blueprint = 1 Then
		        Continue
		      End If
		      
		      Var IDs() As String = SourceKindToModifierID(ModifierID)
		      If IDs.LastIndex = -1 Then
		        IDs.Add(ModifierID)
		      End If
		      
		      For Each ID As String In IDs
		        Var ModifierDict As New Dictionary
		        ModifierDict.Value("MinQuality") = MinQuality
		        ModifierDict.Value("MaxQuality") = MaxQuality
		        ModifierDict.Value("Quantity") = Quantity
		        ModifierDict.Value("Blueprint") = Blueprint
		        Preset.mModifierValues.Value(ID) = ModifierDict
		      Next
		    Next
		  End If
		  
		  Return New Beacon.Preset(Preset)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, CompatibilityFlags = (TargetConsole and (Target32Bit or Target64Bit)) or  (TargetWeb and (Target32Bit or Target64Bit)) or  (TargetDesktop and (Target32Bit or Target64Bit))
		Shared Function FromFile(File As Global.FolderItem) As Beacon.Preset
		  If File = Nil Or File.Exists = False Or File.IsFolder = True Then
		    Return Nil
		  End If
		  
		  Try
		    Var Bytes As String = File.Read(Encodings.UTF8)
		    If Bytes = "" Then
		      Return Nil
		    End If
		    
		    Var Dict As Dictionary = Beacon.ParseJSON(Bytes)
		    Return Beacon.Preset.FromDictionary(Dict)
		  Catch Err As RuntimeException
		    Return Nil
		  End Try
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Grouping() As String
		  If Self.mGrouping.Trim = "" Then
		    Return "Miscellaneous"
		  Else
		    Return Self.mGrouping.Trim
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IndexOf(Entry As Beacon.PresetEntry) As Integer
		  For I As Integer = 0 To Self.mContents.LastIndex
		    If Self.mContents(I) = Entry Then
		      Return I
		    End If
		  Next
		  Return -1
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsCustom() As Boolean
		  Return Beacon.Data.IsPresetCustom(Self)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Iterator() As Iterator
		  Var Contents() As Variant
		  Contents.ResizeTo(Self.mContents.LastIndex)
		  For I As Integer = 0 To Self.mContents.LastIndex
		    Contents(I) = Self.mContents(I)
		  Next
		  Return New Beacon.GenericIterator(Contents)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Label() As String
		  Return Self.mLabel
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function MaxItems() As Integer
		  Return Max(Self.mMaxItems, 1)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function MaxQualityModifier(Modifier As Beacon.PresetModifier) As Integer
		  Return Self.MaxQualityModifier(Modifier.ModifierID)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function MaxQualityModifier(ModifierID As String) As Integer
		  If Self.mModifierValues = Nil Then
		    Return 0
		  End If
		  
		  Var Dict As Dictionary = Self.mModifierValues.Lookup(ModifierID, New Dictionary)
		  If Dict.HasKey("MaxQuality") Then
		    Return Dict.Value("MaxQuality")
		  Else
		    Return Dict.Lookup("Quality", 0)
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function MinItems() As Integer
		  Return Max(Self.mMinItems, 1)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function MinQualityModifier(Modifier As Beacon.PresetModifier) As Integer
		  Return Self.MinQualityModifier(Modifier.ModifierID)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function MinQualityModifier(ModifierID As String) As Integer
		  If Self.mModifierValues = Nil Then
		    Return 0
		  End If
		  
		  Var Dict As Dictionary = Self.mModifierValues.Lookup(ModifierID, New Dictionary)
		  If Dict.HasKey("MinQuality") Then
		    Return Dict.Value("MinQuality")
		  Else
		    Return Dict.Lookup("Quality", 0)
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Operator_Subscript(Index As Integer) As Beacon.PresetEntry
		  Return New Beacon.PresetEntry(Self.mContents(Index))
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function PresetID() As String
		  If Self.mPresetID = "" Then
		    Self.mPresetID = New v4UUID
		  End If
		  Return Self.mPresetID.Lowercase
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function QuantityMultiplier(Modifier As Beacon.PresetModifier) As Double
		  Return Self.QuantityMultiplier(Modifier.ModifierID)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function QuantityMultiplier(ModifierID As String) As Double
		  If Self.mModifierValues = Nil Then
		    Return 1.0
		  End If
		  
		  Var Dict As Dictionary = Self.mModifierValues.Lookup(ModifierID, New Dictionary)
		  Return Dict.Lookup("Quantity", 1.0)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Shared Function SourceKindToModifierID(Kind As String) As String()
		  Var IDs() As String
		  Select Case Kind
		  Case "Bonus"
		    IDs.Add(Beacon.PresetModifier.BonusCratesID)
		    IDs.Add(Beacon.PresetModifier.AberrationSurfaceBonusCratesID)
		  Case "Cave"
		    IDs.Add(Beacon.PresetModifier.CaveCratesID)
		  Case "Sea"
		    IDs.Add(Beacon.PresetModifier.DeepSeaCratesID)
		    IDs.Add(Beacon.PresetModifier.OpenDesertCratesID)
		  Case "Standard"
		    IDs.Add(Beacon.PresetModifier.BasicCratesID)
		    IDs.Add(Beacon.PresetModifier.AberrationSurfaceCratesID)
		    IDs.Add(Beacon.PresetModifier.BossesID)
		    IDs.Add(Beacon.PresetModifier.ArtifactCratesID)
		  End Select
		  Return IDs
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToDictionary(Format As Beacon.Preset.SaveFormats) As Dictionary
		  Var IncludeModern, IncludeLegacy As Boolean
		  Select Case Format
		  Case Beacon.Preset.SaveFormats.Modern
		    IncludeModern = True
		  Case Beacon.Preset.SaveFormats.Legacy
		    IncludeLegacy = True
		  Case Beacon.Preset.SaveFormats.Universal
		    IncludeModern = True
		    IncludeLegacy = True
		  End Select
		  
		  Var Hashes() As String
		  Var Contents(), LegacyEntries() As Dictionary
		  For Each Entry As Beacon.PresetEntry In Self.mContents
		    Hashes.Add(Entry.Hash)
		    If IncludeModern Then
		      Contents.Add(Entry.SaveData(False))
		    End If
		    If IncludeLegacy Then
		      LegacyEntries.Add(Entry.SaveData(True))
		    End If
		  Next
		  If IncludeModern And IncludeLegacy Then
		    Hashes.SortWith(Contents, LegacyEntries)
		  ElseIf IncludeModern Then
		    Hashes.SortWith(Contents)
		  ElseIf IncludeLegacy Then
		    Hashes.SortWith(LegacyEntries)
		  End If
		  
		  Var Dict As New Dictionary
		  If IncludeModern And IncludeLegacy Then
		    Dict.Value("Version") = Self.Version
		    Dict.Value("MinVersion") = 2
		  ElseIf IncludeModern Then
		    Dict.Value("Version") = Self.Version
		    Dict.Value("MinVersion") = Self.Version
		  ElseIf IncludeLegacy Then
		    Dict.Value("Version") = 2
		    Dict.Value("MinVersion") = 2
		  End If
		  Dict.Value("ID") = Self.PresetID
		  Dict.Value("Label") = Self.Label
		  Dict.Value("Grouping") = Self.Grouping
		  Dict.Value("Min") = Self.MinItems
		  Dict.Value("Max") = Self.MaxItems
		  If IncludeModern Then
		    Dict.Value("ItemSets") = Contents
		  End If
		  If IncludeLegacy Then
		    Dict.Value("Entries") = LegacyEntries
		  End If
		  Dict.Value("Modifiers") = Self.mModifierValues
		  
		  If IncludeLegacy Then
		    Var Definitions() As Dictionary
		    For Each Entry As DictionaryEntry In Self.mModifierValues
		      Var ModifierID As String = Entry.Key
		      Var Modifier As Beacon.PresetModifier = Beacon.Data.GetPresetModifier(ModifierID)
		      If (Modifier Is Nil) = False And Modifier.UsesAdvancedPattern = False Then
		        Definitions.Add(Modifier.ToDictionary(True))
		      End If
		    Next Entry
		    Dict.Value("Modifier Definitions") = Definitions
		  End If
		  
		  Return Dict
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, CompatibilityFlags = (TargetConsole and (Target32Bit or Target64Bit)) or  (TargetWeb and (Target32Bit or Target64Bit)) or  (TargetDesktop and (Target32Bit or Target64Bit))
		Sub ToFile(File As FolderItem, Format As Beacon.Preset.SaveFormats)
		  Call File.Write(Beacon.GenerateJSON(Self.ToDictionary(Format), True))
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ValidForMap(Map As Beacon.Map) As Boolean
		  Return Self.ValidForMask(Map.Mask)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ValidForMask(Mask As UInt64) As Boolean
		  If Mask = CType(0, UInt64) Then
		    Return True
		  End If
		  
		  For Each Entry As Beacon.PresetEntry In Self.mContents
		    If Entry.ValidForMask(Mask) Then
		      Return True
		    End If
		  Next
		End Function
	#tag EndMethod


	#tag Property, Flags = &h1
		Protected mContents() As Beacon.PresetEntry
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected mGrouping As String
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected mLabel As String
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected mMaxItems As Integer
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected mMinItems As Integer
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected mModifierValues As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mPresetID As String
	#tag EndProperty

	#tag Property, Flags = &h0
		Type As Beacon.Preset.Types
	#tag EndProperty


	#tag Constant, Name = Version, Type = Double, Dynamic = False, Default = \"3", Scope = Public
	#tag EndConstant


	#tag Enum, Name = SaveFormats, Type = Integer, Flags = &h0
		Modern
		  Legacy
		Universal
	#tag EndEnum

	#tag Enum, Name = Types, Type = Integer, Flags = &h0
		BuiltIn
		  Custom
		CustomizedBuiltIn
	#tag EndEnum


	#tag ViewBehavior
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Type"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Beacon.Preset.Types"
			EditorType="Enum"
			#tag EnumValues
				"0 - BuiltIn"
				"1 - Custom"
				"2 - CustomizedBuiltIn"
			#tag EndEnumValues
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
