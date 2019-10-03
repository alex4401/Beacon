#tag Class
Protected Class Rewriter
Inherits Global.Thread
	#tag Event
		Sub Run()
		  Self.mFinished = False
		  Self.mTriggers.AddRow(CallLater.Schedule(1, WeakAddressOf TriggerStarted))
		  Dim Errored As Boolean
		  Self.mUpdatedContent = Self.Rewrite(Self.mInitialContent, Self.mMode, Self.mDocument, Self.mIdentity, If(Self.mWithMarkup, Self.mDocument.TrustKey, ""), Self.mProfile, If(Self.mDocument.AllowUCS, Beacon.Rewriter.EncodingFormat.UCS2AndASCII, Beacon.Rewriter.EncodingFormat.ASCII), Errored)
		  Self.mFinished = True
		  Self.mErrored = Errored
		  Self.mTriggers.AddRow(CallLater.Schedule(1, WeakAddressOf TriggerFinished))
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub Cancel()
		  If Self.ThreadState <> Thread.ThreadStates.NotRunning Then
		    Self.Stop
		  End If
		  
		  For I As Integer = Self.mTriggers.LastRowIndex DownTo 0
		    CallLater.Cancel(Self.mTriggers(I))
		    Self.mTriggers.RemoveRowAt(I)
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function ConvertEncoding(Content As String, Format As Beacon.Rewriter.EncodingFormat) As String
		  If Format = Beacon.Rewriter.EncodingFormat.Unicode Then
		    If Content.Encoding <> Encodings.UTF8 Then
		      Content = Content.ConvertEncoding(Encodings.UTF8)
		    End If
		    Return Content
		  End If
		  
		  If Format = Beacon.Rewriter.EncodingFormat.UCS2AndASCII And Encodings.ASCII.IsValidData(Content) = False Then
		    Dim Reg As New RegEx
		    Reg.SearchPattern = "[\x{10000}-\x{10FFFF}]"
		    Reg.ReplacementPattern = "?"
		    Reg.Options.ReplaceAllMatches = True
		    Try
		      Content = Reg.Replace(Content)
		    Catch Err As RegExSearchPatternException
		      Return Content.ConvertEncoding(Encodings.ASCII)
		    End Try
		    
		    Return Encodings.ASCII.Chr(&hFF) + Encodings.ASCII.Chr(&hFE) + Content.ConvertEncoding(Encodings.UTF16LE)
		  End If
		  
		  If Content.Encoding <> Encodings.ASCII Then
		    Content = Content.ConvertEncoding(Encodings.ASCII)
		  End If
		  
		  Return Content
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Destructor()
		  For I As Integer = Self.mTriggers.LastRowIndex DownTo 0
		    CallLater.Cancel(Self.mTriggers(I))
		    Self.mTriggers.RemoveRowAt(I)
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Errored() As Boolean
		  Return Self.mErrored
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Finished() As Boolean
		  Return Self.mFinished
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Mode() As String
		  Return Self.mMode
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function Rewrite(InitialContent As String, ConfigDict As Dictionary, TrustKey As String, Format As Beacon.Rewriter.EncodingFormat, ByRef Errored As Boolean) As String
		  Try
		    // Normalize line endings
		    Dim EOL As String = InitialContent.DetectLineEnding
		    InitialContent = InitialContent.ReplaceLineEndings(Encodings.UTF8.Chr(10))
		    
		    // Organize all existing content
		    Dim Lines() As String = InitialContent.Split(Encodings.ASCII.Chr(10))
		    Dim UntouchedConfigs As New Dictionary
		    Dim LastGroupHeader As String
		    For I As Integer = 0 To Lines.LastRowIndex
		      Dim Line As String = Lines(I).Trim
		      If Line.Length = 0 Then
		        Continue
		      End If
		      
		      If Line.BeginsWith("[") And Line.EndsWith("]") Then
		        // This is a group header
		        LastGroupHeader = Line.Middle(1, Line.Length - 2)
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
		      ConfigLines.AddRow(Line)
		      SectionDict.Value(Key) = ConfigLines
		      UntouchedConfigs.Value(LastGroupHeader) = SectionDict
		    Next
		    
		    Dim AllSectionHeaders() As String
		    Dim UntouchedKeys() As Variant = UntouchedConfigs.Keys
		    For Each UntouchedKey As String In UntouchedKeys
		      AllSectionHeaders.AddRow(UntouchedKey)
		    Next
		    Dim NewKeys() As Variant = ConfigDict.Keys
		    For Each NewKey As String In NewKeys
		      If AllSectionHeaders.IndexOf(NewKey) = -1 Then
		        AllSectionHeaders.AddRow(NewKey)
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
		        Dim Value As String = BuildLine.Middle(ValuePos)
		        If Value.BeginsWith("""") And Value.EndsWith("""") Then
		          Value = Value.Middle(1, Value.Length - 2)
		        End If
		        BeaconGroupVersion = Val(Value)
		      End If
		      
		      Dim IsTrusted As Boolean
		      If BeaconDict.HasKey("Trust") Then
		        Dim TrustLines() As String = BeaconDict.Value("Trust")
		        For Each TrustLine As String In TrustLines
		          If TrustLine = "Trust=" + TrustKey Then
		            IsTrusted = True
		            Exit
		          End If
		        Next
		      Else
		        IsTrusted = True
		      End If
		      
		      If IsTrusted Then
		        If BeaconDict.HasKey("ManagedKeys") Then
		          Dim ManagedKeyLines() As String = BeaconDict.Value("ManagedKeys")
		          For Each KeyLine As String In ManagedKeyLines
		            Dim Header, ArrayTextContent As String
		            
		            If BeaconGroupVersion > 10103300 Then
		              Dim HeaderStartPos As Integer = KeyLine.IndexOf(13, "Section=""") + 9
		              Dim HeaderEndPos As Integer = KeyLine.IndexOf(HeaderStartPos, """")
		              Header = KeyLine.Middle(HeaderStartPos, HeaderEndPos - HeaderStartPos)
		              If Not UntouchedConfigs.HasKey(Header) Then
		                Continue
		              End If
		              
		              Dim ArrayStartPos As Integer = KeyLine.IndexOf(13, "Keys=(") + 6
		              Dim ArrayEndPos As Integer = KeyLine.IndexOf(ArrayStartPos, ")")
		              ArrayTextContent = KeyLine.Middle(ArrayStartPos, ArrayEndPos - ArrayStartPos)
		            Else
		              Dim HeaderPos As Integer = KeyLine.IndexOf("['") + 2
		              Dim HeaderEndPos As Integer = KeyLine.IndexOf(HeaderPos, "']")
		              Header = KeyLine.Middle(HeaderPos, HeaderEndPos - HeaderPos)
		              If Not UntouchedConfigs.HasKey(Header) Then
		                Continue
		              End If
		              
		              Dim ArrayPos As Integer = KeyLine.IndexOf(HeaderEndPos, "(") + 1
		              Dim ArrayEndPos As Integer = KeyLine.IndexOf(ArrayPos, ")")
		              ArrayTextContent = KeyLine.Middle(ArrayPos, ArrayEndPos - ArrayPos)
		            End If
		            
		            Dim ManagedKeys() As String = ArrayTextContent.Split(",")
		            Dim SectionContents As Dictionary = UntouchedConfigs.Value(Header)
		            For Each ManagedKey As String In ManagedKeys
		              If SectionContents.HasKey(ManagedKey) Then
		                SectionContents.Remove(ManagedKey)
		              End If
		            Next
		            If SectionContents.KeyCount = 0 Then
		              UntouchedConfigs.Remove(Header)
		            End If
		          Next
		        End If
		      End If
		      
		      If UntouchedConfigs.HasKey("Beacon") Then
		        UntouchedConfigs.Remove("Beacon")
		      End If
		      AllSectionHeaders.RemoveRowAt(AllSectionHeaders.IndexOf("Beacon"))
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
		        If OldContents.KeyCount = 0 Then
		          UntouchedConfigs.Remove(Header)
		        End If
		      Next
		    End If
		    
		    // Setup the Beacon section
		    If TrustKey <> "" Then
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
		            Keys.AddRow(Entry)
		          End If
		        Next
		        
		        BeaconKeys.Value(Header) = Keys
		      Next
		      If BeaconKeys.KeyCount > 0 Then
		        Dim BeaconDict As New Dictionary
		        Dim BeaconKeysKeys() As Variant = BeaconKeys.Keys
		        For Each Header As String In BeaconKeysKeys
		          Dim Keys() As String = BeaconKeys.Value(Header)
		          Dim SectionLines() As String
		          If BeaconDict.HasKey("ManagedKeys") Then
		            SectionLines = BeaconDict.Value("ManagedKeys")
		          End If
		          SectionLines.AddRow("ManagedKeys=(Section=""" + Header + """,Keys=(" + Keys.Join(",") + "))")
		          BeaconDict.Value("ManagedKeys") = SectionLines
		        Next
		        BeaconDict.Value("Build") = Array("Build=" + Str(App.BuildNumber, "0"))
		        BeaconDict.Value("Trust") = Array("Trust=" + TrustKey)
		        BeaconDict.Value("LastUpdated") = Array("LastUpdated=""" + DateTime.Now.SQLDateTimeWithOffset + """")
		        AllSectionHeaders.AddRow("Beacon")
		        ConfigDict.Value("Beacon") = BeaconDict
		      End If
		    End If
		    
		    // Build an ini file
		    Dim NewLines() As String
		    AllSectionHeaders.Sort
		    For Each Header As String In AllSectionHeaders
		      If NewLines.LastRowIndex > -1 Then
		        NewLines.AddRow("")
		      End If
		      NewLines.AddRow("[" + Header + "]")
		      
		      Dim SectionConfigs() As String
		      
		      If UntouchedConfigs.HasKey(Header) Then
		        Dim Section As Dictionary = UntouchedConfigs.Value(Header)
		        Dim SectionKeys() As Variant = Section.Keys
		        For Each Key As Variant In SectionKeys
		          If SectionConfigs.IndexOf(Key) = -1 Then
		            SectionConfigs.AddRow(Key)
		          End If
		        Next
		      End If
		      
		      If ConfigDict.HasKey(Header) Then
		        Dim Section As Dictionary = ConfigDict.Value(Header)
		        Dim SectionKeys() As Variant = Section.Keys
		        For Each Key As Variant In SectionKeys
		          If SectionConfigs.IndexOf(Key) = -1 Then
		            SectionConfigs.AddRow(Key)
		          End If
		        Next
		      End If
		      
		      SectionConfigs.Sort
		      
		      For Each ConfigKey As String In SectionConfigs
		        If UntouchedConfigs.HasKey(Header) Then
		          Dim Section As Dictionary = UntouchedConfigs.Value(Header)
		          If Section.HasKey(ConfigKey) Then
		            Dim Values() As String = Section.Value(ConfigKey)
		            For Each Line As String In Values
		              NewLines.AddRow(Line)
		            Next
		          End If
		        End If
		        If ConfigDict.HasKey(Header) Then
		          Dim Section As Dictionary = ConfigDict.Value(Header)
		          If Section.HasKey(ConfigKey) Then
		            Dim Values() As String = Section.Value(ConfigKey)
		            For Each Line As String In Values
		              NewLines.AddRow(Line)
		            Next
		          End If
		        End If
		      Next
		    Next
		    
		    Dim Result As String = ConvertEncoding(NewLines.Join(EOL), Format)
		    Errored = False
		    Return Result
		  Catch Err As RuntimeException
		    Errored = True
		  End Try
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Rewrite(InitialContent As String, Mode As String, Document As Beacon.Document, Identity As Beacon.Identity, WithMarkup As Boolean, Profile As Beacon.ServerProfile)
		  Self.mWithMarkup = WithMarkup
		  Self.mInitialContent = InitialContent
		  Self.mMode = Mode
		  Self.mDocument = Document
		  Self.mIdentity = Identity
		  Self.mProfile = Profile
		  
		  Super.Start
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function Rewrite(InitialContent As String, Mode As String, Document As Beacon.Document, Identity As Beacon.Identity, TrustKey As String, Profile As Beacon.ServerProfile, Format As Beacon.Rewriter.EncodingFormat, ByRef Errored As Boolean) As String
		  Try
		    Dim ConfigDict As New Dictionary
		    Dim CustomContentGroup As BeaconConfigs.CustomContent
		    
		    Dim Groups() As Beacon.ConfigGroup = Document.ImplementedConfigs
		    For Each Group As Beacon.ConfigGroup In Groups
		      If Group.ConfigName = BeaconConfigs.CustomContent.ConfigName Then
		        CustomContentGroup = BeaconConfigs.CustomContent(Group)
		        Continue
		      End If
		      
		      Dim Options() As Beacon.ConfigValue
		      Select Case Mode
		      Case Beacon.RewriteModeGameIni
		        Options = Group.GameIniValues(Document, Identity, Profile)
		      Case Beacon.RewriteModeGameUserSettingsIni
		        Options = Group.GameUserSettingsIniValues(Document, Identity, Profile)
		      End Select
		      If Options <> Nil And Options.LastRowIndex > -1 Then
		        Beacon.ConfigValue.FillConfigDict(ConfigDict, Options)
		      End If
		    Next
		    
		    If CustomContentGroup <> Nil Then
		      Dim Options() As Beacon.ConfigValue
		      Select Case Mode
		      Case Beacon.RewriteModeGameIni
		        Options = CustomContentGroup.GameIniValues(Document, ConfigDict, Profile)
		      Case Beacon.RewriteModeGameUserSettingsIni
		        Options = CustomContentGroup.GameUserSettingsIniValues(Document, ConfigDict, Profile)
		      End Select
		      If Options <> Nil And Options.LastRowIndex > -1 Then
		        Beacon.ConfigValue.FillConfigDict(ConfigDict, Options)
		      End If
		    End If
		    
		    Return Rewrite(InitialContent, ConfigDict, TrustKey, Format, Errored)
		  Catch Err As RuntimeException
		    Errored = True
		  End Try
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Run()
		  Super.Start
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub TriggerFinished()
		  RaiseEvent Finished
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub TriggerStarted()
		  RaiseEvent Started
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function UpdatedContent() As String
		  Return Self.mUpdatedContent
		End Function
	#tag EndMethod


	#tag Hook, Flags = &h0
		Event Finished()
	#tag EndHook

	#tag Hook, Flags = &h0
		Event Started()
	#tag EndHook


	#tag Property, Flags = &h21
		Private mDocument As Beacon.Document
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mErrored As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mFinished As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mIdentity As Beacon.Identity
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mInitialContent As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mMode As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mProfile As Beacon.ServerProfile
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mTriggers() As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mUpdatedContent As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mWithMarkup As Boolean
	#tag EndProperty


	#tag Enum, Name = EncodingFormat, Type = Integer, Flags = &h0
		Unicode
		  UCS2AndASCII
		ASCII
	#tag EndEnum


	#tag ViewBehavior
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="Integer"
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
			Name="Priority"
			Visible=true
			Group="Behavior"
			InitialValue="5"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="StackSize"
			Visible=true
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
