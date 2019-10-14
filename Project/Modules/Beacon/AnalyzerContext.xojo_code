#tag Class
Protected Class AnalyzerContext
	#tag Method, Flags = &h0
		Sub ConfigValue(File As String, Section As String, Key As String)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(Identity As Beacon.Identity, GameIniSource As String, GameUserSettingsIniSource As String)
		  Self.mIdentity = Identity
		  Self.mFiles = New Dictionary
		  Self.ParseContent(GameIniSource, Self.FileGameIni, SectionShooterGame)
		  Self.ParseContent(GameUserSettingsIniSource, Self.FileGameUserSettingsIni, SectionServerSettings)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function FileGameIni() As String
		  Return "Game.ini"
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function FileGameUserSettingsIni() As String
		  Return "GameUserSettings.ini"
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function GetFileDict(Filename As String) As Dictionary
		  If Not Self.mFiles.HasKey(Filename) Then
		    Return Nil
		  End If
		  Return Self.mFiles.HasKey(Filename)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function GetSectionDict(Filename As String, Section As String) As Dictionary
		  Dim Files As Dictionary = Self.GetFileDict(Filename)
		  If Files = Nil Then
		    Return Nil
		  End If
		  
		  If Files.HasKey(Section) Then
		    Return File.Value(Section)
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function HasConfig(Key As String) As Boolean
		  Dim Parts() As String = Key.Split(":")
		  If Parts.LastRowIndex <> 2 Then
		    Dim Err As New UnsupportedOperationException
		    Err.Message = "Config key request string must be 3 parts. Offending key: " + Key
		    Raise Err
		  End If
		  
		  Return Self.HasConfig(Parts(0), Parts(1), Parts(2))
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function HasConfig(File As String, Section As String, Key As String) As Boolean
		  Var FileDict As Dictionary
		  If Self.mFiles.HasKey(File) Then
		    FileDict = Self.mFiles.Value(File)
		  Else
		    Return False
		  End If
		  
		  Var SectionDict As Dictionary
		  If FileDict.HasKey(Section) Then
		    SectionDict = FileDict.Value(Section)
		  Else
		    Return False
		  End If
		  
		  Return SectionDict.HasKey(Key)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsOmni() As Boolean
		  Return Self.mIdentity.OmniVersion >= Beacon.OmniVersion
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ParseContent(Content As String, Filename As String, InitialSection As String)
		  Content = Content.ReplaceLineEndings(EndOfLine)
		  
		  Var CurrentSection As String = InitialSection
		  
		  Var Lines() As String = Content.Split(EndOfLine)
		  Var FileSections As New Dictionary
		  Var Section As New Dictionary
		  For Each Line As String In Lines
		    Line = Line.Trim
		    If Line.Length = 0 Then
		      Continue
		    ElseIf Line.BeginsWith("[") And Line.EndsWith("]") Then
		      FileSections.Value(CurrentSection) = Section
		      CurrentSection = Line.Middle(1, Line.Length - 2)
		      If FileSections.HasKey(CurrentSection) Then
		        Section = FileSections.Value(CurrentSection)
		      Else
		        Section = New Dictionary
		      End If
		      Continue
		    ElseIf Line.BeginsWith("#") Or Line.BeginsWith("//") Then
		      Continue
		    End If
		    
		    Dim Pos As Integer = Line.IndexOf("=")
		    If Pos = -1 Then
		      Continue
		    End If
		    
		    Var Key As String = Line.Left(Pos)
		    Var Value As String = Line.Middle(Pos + 1)
		    
		    Var KeyValues() As String
		    If Section.HasKey(Key) Then
		      KeyValues = Section.Value(Key)
		    End If
		    KeyValues.AddRow(Value)
		    Section.Value(Key) = KeyValues
		  Next
		  FileSections.Value(CurrentSection) = Section
		  Self.mFiles.Value(Filename) = FileSections
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function SectionMessageOfTheDay() As String
		  Return "MessageOfTheDay"
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function SectionServerSettings() As String
		  Return Beacon.ServerSettingsHeader
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function SectionSessionSettings() As String
		  Return "SessionSettings"
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function SectionShooterGame() As String
		  Return Beacon.ShooterGameHeader
		End Function
	#tag EndMethod


	#tag Property, Flags = &h21
		Private mFiles As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mIdentity As Beacon.Identity
	#tag EndProperty


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
			InitialValue="-2147483648"
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
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
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
	#tag EndViewBehavior
End Class
#tag EndClass
