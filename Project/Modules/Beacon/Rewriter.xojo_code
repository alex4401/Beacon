#tag Class
Protected Class Rewriter
Inherits Thread
	#tag Event
		Sub Run()
		  Dim ConfigDict As New Dictionary
		  Dim CustomContentGroup As BeaconConfigs.CustomContent
		  
		  Dim Groups() As Beacon.ConfigGroup = Self.Document.ImplementedConfigs
		  For Each Group As Beacon.ConfigGroup In Groups
		    If Group.ConfigName = BeaconConfigs.CustomContent.ConfigName Then
		      CustomContentGroup = BeaconConfigs.CustomContent(Group)
		      Continue
		    End If
		    
		    Dim Options() As Beacon.ConfigValue
		    Select Case Self.Mode
		    Case Beacon.RewriteModeGameIni
		      Options = Group.GameIniValues(Self.Document, Self.Identity, Self.Mask)
		    Case Beacon.RewriteModeGameUserSettingsIni
		      Options = Group.GameUserSettingsIniValues(Self.Document, Self.Identity, Self.Mask)
		    End Select
		    If Options <> Nil And Options.Ubound > -1 Then
		      Beacon.ConfigValue.FillConfigDict(ConfigDict, Options)
		    End If
		  Next
		  
		  If CustomContentGroup <> Nil Then
		    Dim Options() As Beacon.ConfigValue
		    Select Case Self.Mode
		    Case Beacon.RewriteModeGameIni
		      Options = CustomContentGroup.GameIniValues(Self.Document, Self.Identity, Self.Mask)
		    Case Beacon.RewriteModeGameUserSettingsIni
		      Options = CustomContentGroup.GameUserSettingsIniValues(Self.Document, Self.Identity, Self.Mask)
		    End Select
		    If Options <> Nil And Options.Ubound > -1 Then
		      Beacon.ConfigValue.FillConfigDict(ConfigDict, Options)
		    End If
		  End If
		  
		  // Normalize line endings
		  Dim InitialContent As String = Self.InitialContent
		  Dim EOL As String = InitialContent.DetectLineEnding
		  InitialContent = ReplaceLineEndings(InitialContent, Chr(10))
		  
		  // Organize all existing content
		  Dim Lines() As String = InitialContent.Split(Chr(10))
		  Dim UntouchedConfigs As New Dictionary
		  Dim LastGroupHeader As String
		  For I As Integer = 0 To Lines.Ubound
		    Dim Line As String = Lines(I).Trim
		    If Line.Length = 0 Then
		      Continue
		    End If
		    
		    If Line.BeginsWith("[") And Line.EndsWith("]") Then
		      // This is a group header
		      LastGroupHeader = Line.SubString(1, Line.Length - 2)
		      Continue
		    End If
		    
		    Dim SectionDict As Dictionary
		    If UntouchedConfigs.HasKey(LastGroupHeader) Then
		      SectionDict = UntouchedConfigs.Value(LastGroupHeader)
		    Else
		      SectionDict = New Dictionary
		    End If
		    
		    Dim KeyPos As Integer = Line.IndexOf("=")
		    If KeyPos = -1 Then
		      Continue
		    End If
		    
		    Dim Key As String = Line.Left(KeyPos)
		    Dim ModifierPos As Integer = Key.IndexOf("[")
		    If ModifierPos > -1 Then
		      Key = Key.Left(ModifierPos)
		    End If
		    
		    If ConfigDict.HasKey(LastGroupHeader) Then
		      Dim NewConfigSection As Dictionary = ConfigDict.Value(LastGroupHeader)
		      If NewConfigSection.HasKey(Key) Then
		        // This key is being overridden by Beacon
		        Continue
		      End If
		    End If
		    
		    Dim ConfigLines() As String
		    If SectionDict.HasKey(Key) Then
		      ConfigLines = SectionDict.Value(Key)
		    End If
		    ConfigLines.Append(Line)
		    SectionDict.Value(Key) = ConfigLines
		    UntouchedConfigs.Value(LastGroupHeader) = SectionDict
		  Next
		  
		  Dim AllSectionHeaders() As String
		  Dim UntouchedKeys() As Variant = UntouchedConfigs.Keys
		  For Each UntouchedKey As String In UntouchedKeys
		    AllSectionHeaders.Append(UntouchedKey)
		  Next
		  Dim NewKeys() As Variant = ConfigDict.Keys
		  For Each NewKey As String In NewKeys
		    If AllSectionHeaders.IndexOf(NewKey) = -1 Then
		      AllSectionHeaders.Append(NewKey)
		    End If
		  Next
		  
		  // Figure out which keys are managed by Beacon so they can be removed
		  If UntouchedConfigs.HasKey("Beacon") Then
		    // Generated by a version of Beacon that includes its own config section
		    Dim BeaconDict As Dictionary = UntouchedConfigs.Value("Beacon")
		    Dim BeaconGroupVersion As Integer = 10103300
		    If BeaconDict.HasKey("Build") Then
		      Dim BuildLines() As String = BeaconDict.Value("Build")
		      Dim BuildLine As String = BuildLines(0)
		      Dim ValuePos As Integer = BuildLine.IndexOf("=") + 1
		      Dim Value As String = BuildLine.SubString(ValuePos)
		      If Value.BeginsWith("""") And Value.EndsWith("""") Then
		        Value = Value.SubString(1, Value.Length - 2)
		      End If
		      BeaconGroupVersion = Val(Value)
		    End If
		    
		    If BeaconDict.HasKey("ManagedKeys") Then
		      Dim ManagedKeyLines() As String = BeaconDict.Value("ManagedKeys")
		      For Each KeyLine As String In ManagedKeyLines
		        Dim Header, ArrayTextContent As String
		        
		        If BeaconGroupVersion > 10103300 Then
		          Dim HeaderStartPos As Integer = KeyLine.IndexOf(13, "Section=""") + 9
		          Dim HeaderEndPos As Integer = KeyLine.IndexOf(HeaderStartPos, """")
		          Header = KeyLine.SubString(HeaderStartPos, HeaderEndPos - HeaderStartPos)
		          If Not UntouchedConfigs.HasKey(Header) Then
		            Continue
		          End If
		          
		          Dim ArrayStartPos As Integer = KeyLine.IndexOf(13, "Keys=(") + 6
		          Dim ArrayEndPos As Integer = KeyLine.IndexOf(ArrayStartPos, ")")
		          ArrayTextContent = KeyLine.SubString(ArrayStartPos, ArrayEndPos - ArrayStartPos)
		        Else
		          Dim HeaderPos As Integer = KeyLine.IndexOf("['") + 2
		          Dim HeaderEndPos As Integer = KeyLine.IndexOf(HeaderPos, "']")
		          Header = KeyLine.SubString(HeaderPos, HeaderEndPos - HeaderPos)
		          If Not UntouchedConfigs.HasKey(Header) Then
		            Continue
		          End If
		          
		          Dim ArrayPos As Integer = KeyLine.IndexOf(HeaderEndPos, "(") + 1
		          Dim ArrayEndPos As Integer = KeyLine.IndexOf(ArrayPos, ")")
		          ArrayTextContent = KeyLine.Mid(ArrayPos, ArrayEndPos - ArrayPos)
		        End If
		        
		        Dim ManagedKeys() As String = ArrayTextContent.Split(",")
		        Dim SectionContents As Dictionary = UntouchedConfigs.Value(Header)
		        For Each ManagedKey As String In ManagedKeys
		          If SectionContents.HasKey(ManagedKey) Then
		            SectionContents.Remove(ManagedKey)
		          End If
		        Next
		        If SectionContents.Count = 0 Then
		          UntouchedConfigs.Remove(Header)
		        End If
		      Next
		    End If
		    If UntouchedConfigs.HasKey("Beacon") Then
		      UntouchedConfigs.Remove("Beacon")
		    End If
		    AllSectionHeaders.Remove(AllSectionHeaders.IndexOf("Beacon"))
		  Else
		    // We'll need to use the legacy style of removing only what is being replaced
		    For Each Header As String In NewKeys
		      If Not UntouchedConfigs.HasKey(Header) Then
		        Continue
		      End If
		      
		      Dim OldContents As Dictionary = UntouchedConfigs.Value(Header)
		      Dim NewContents As Dictionary = ConfigDict.Value(Header)
		      Dim NewContentKeys() As Variant = NewContents.Keys
		      For Each NewContentKey As String In NewContentKeys
		        If OldContents.HasKey(NewContentKey) Then
		          OldContents.Remove(NewContentKey)
		        End If
		      Next
		      If OldContents.Count = 0 Then
		        UntouchedConfigs.Remove(Header)
		      End If
		    Next
		  End If
		  
		  // Setup the Beacon section
		  If Self.WithMarkup Then
		    Dim BeaconKeys As New Dictionary
		    For Each Header As String In NewKeys
		      Dim Keys() As String
		      If BeaconKeys.HasKey(Header) Then
		        Keys = BeaconKeys.Value(Header)
		      End If
		      
		      Dim Dict As Dictionary = ConfigDict.Value(Header)
		      Dim Entries() As Variant = Dict.Keys
		      For Each Entry As String In Entries
		        If Keys.IndexOf(Entry) = -1 Then
		          Keys.Append(Entry)
		        End If
		      Next
		      
		      BeaconKeys.Value(Header) = Keys
		    Next
		    If BeaconKeys.Count > 0 Then
		      Dim BeaconDict As New Dictionary
		      Dim BeaconKeysKeys() As Variant = BeaconKeys.Keys
		      For Each Header As String In BeaconKeysKeys
		        Dim Keys() As String = BeaconKeys.Value(Header)
		        Dim SectionLines() As String
		        If BeaconDict.HasKey("ManagedKeys") Then
		          SectionLines = BeaconDict.Value("ManagedKeys")
		        End If
		        SectionLines.Append("ManagedKeys=(Section=""" + Header + """,Keys=(" + Keys.Join(",") + "))")
		        BeaconDict.Value("ManagedKeys") = SectionLines
		      Next
		      BeaconDict.Value("Build") = Array("Build=" + Str(App.BuildNumber, "0"))
		      AllSectionHeaders.Append("Beacon")
		      ConfigDict.Value("Beacon") = BeaconDict
		    End If
		  End If
		  
		  // Build an ini file
		  Dim NewLines() As String
		  AllSectionHeaders.Sort
		  For Each Header As String In AllSectionHeaders
		    If NewLines.Ubound > -1 Then
		      NewLines.Append("")
		    End If
		    NewLines.Append("[" + Header + "]")
		    
		    If UntouchedConfigs.HasKey(Header) Then
		      Dim Section As Dictionary = UntouchedConfigs.Value(Header)
		      Dim SectionKeys() As Variant = Section.Keys
		      For Each Key As Variant In SectionKeys
		        Dim Values() As String = Section.Value(Key)
		        For Each Line As String In Values
		          NewLines.Append(Line)
		        Next
		      Next
		    End If
		    
		    If ConfigDict.HasKey(Header) Then
		      Dim Section As Dictionary = ConfigDict.Value(Header)
		      Dim SectionKeys() As Variant = Section.Keys
		      For Each Key As Variant In SectionKeys
		        Dim Values() As String = Section.Value(Key)
		        For Each Line As String In Values
		          NewLines.Append(Line)
		        Next
		      Next
		    End If
		  Next
		  
		  Self.UpdatedContent = NewLines.Join(EOL)
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub Constructor(InitialContent As String, Mode As String, Document As Beacon.Document, Identity As Beacon.Identity, Mask As UInt64, WithMarkup As Boolean)
		  Self.WithMarkup = WithMarkup
		  Self.InitialContent = InitialContent
		  Self.Mode = Mode
		  Self.Document = Document
		  Self.Identity = Identity
		  Self.Mask = Mask
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Finished() As Boolean
		  Return Self.UpdatedContent <> ""
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function UpdatedContent() As String
		  Return Self.UpdatedContent
		End Function
	#tag EndMethod


	#tag Property, Flags = &h21
		Private Document As Beacon.Document
	#tag EndProperty

	#tag Property, Flags = &h21
		Private Identity As Beacon.Identity
	#tag EndProperty

	#tag Property, Flags = &h21
		Private InitialContent As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private Mask As UInt64
	#tag EndProperty

	#tag Property, Flags = &h21
		Private Mode As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private UpdatedContent As String
	#tag EndProperty

	#tag Property, Flags = &h0
		WithMarkup As Boolean
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			Type="String"
			EditorType="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			Type="Integer"
			EditorType="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
			EditorType="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Priority"
			Visible=true
			Group="Behavior"
			InitialValue="5"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="StackSize"
			Visible=true
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="WithMarkup"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
