#tag Class
Protected Class ImportThread
Inherits Beacon.Thread
	#tag Event
		Sub Run()
		  Self.mFinished = False
		  Self.Invalidate
		  
		  Dim LineEnding As String = Self.LineEndingChar()
		  
		  // Normalize line endings
		  Dim Content As String = Self.mGameUserSettingsIniContent.ReplaceLineEndings(LineEnding) + LineEnding + Self.mGameIniContent.ReplaceLineEndings(LineEnding)
		  Self.mCharactersProcessed = 0
		  Self.mCharactersTotal = Content.Length
		  
		  Self.mParsedData = New Dictionary
		  
		  Dim Lines() As String = Content.Split(LineEnding)
		  Self.mCharactersTotal = Self.mCharactersTotal + ((Lines.LastRowIndex + 1) * LineEnding.Length) // To account for the trailing line ending characters we're adding
		  For Each Line As String In Lines
		    If Self.mCancelled Then
		      Return
		    End If
		    
		    If Line.Length = 0 Or Line.Left(1) = ";" Then
		      Self.mCharactersProcessed = Self.mCharactersProcessed + Line.Length + LineEnding.Length
		      Self.Invalidate
		      Continue
		    End If
		    
		    Try
		      Dim Value As Variant = Self.Import(Line + LineEnding)
		      If Value = Nil Then
		        Continue
		      End If
		      If Value.Type <> Variant.TypeObject Or Value IsA Beacon.Pair = False Then
		        Continue
		      End If
		      
		      Dim Key As String = Beacon.Pair(Value).Key
		      Value = Beacon.Pair(Value).Value
		      
		      If Self.mParsedData.HasKey(Key) Then
		        Dim ExistingValue As Variant = Self.mParsedData.Value(Key)
		        
		        Dim ValueArray() As Variant
		        If ExistingValue.IsArray Then
		          ValueArray = ExistingValue
		        Else
		          ValueArray.AddRow(ExistingValue)
		        End If
		        ValueArray.AddRow(Value)
		        Self.mParsedData.Value(Key) = ValueArray
		      Else
		        Self.mParsedData.Value(Key) = Value
		      End If
		    Catch Stop As Beacon.ThreadStopException
		      Self.mUpdateTimer.RunMode = Timer.RunModes.Off
		      Return
		    Catch Err As RuntimeException
		      // Don't let an error halt processing, skip and move on
		    End Try
		    Self.Invalidate
		  Next
		  
		  Self.Invalidate
		  Self.mCharactersProcessed = Self.mCharactersTotal
		  
		  RaiseEvent ThreadedParseFinished(Self.mParsedData)
		  
		  Self.mFinished = True
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub Cancel()
		  Self.mCancelled = True
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Clear()
		  Self.mGameIniContent = ""
		  Self.mGameUserSettingsIniContent = ""
		  Self.mFinished = False
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor()
		  Self.mUpdateTimer = New Timer
		  Self.mUpdateTimer.RunMode = Timer.RunModes.Off
		  Self.mUpdateTimer.Period = 0
		  AddHandler Self.mUpdateTimer.Run, WeakAddressOf Self.mUpdateTimer_Run
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Finished() As Boolean
		  Return Self.mFinished
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function Import(Content As String) As Variant
		  Dim Parser As New Beacon.ConfigParser
		  Dim Value As Variant
		  Dim Characters() As String = Content.Split("")
		  For Each Char As String In Characters
		    If Self.mCancelled Then
		      Return Nil
		    End If
		    
		    If Parser.AddCharacter(Char) Then
		      Value = Parser.Value
		      Exit
		    End If
		    Self.mCharactersProcessed = Self.mCharactersProcessed + 1
		    Self.Invalidate
		  Next
		  
		  Return Self.ToXojoType(Value)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Invalidate()
		  If Self.mFinished Then
		    Return
		  End If
		  
		  If Self.mUpdateTimer.RunMode = Timer.RunModes.Off Then
		    Self.mUpdateTimer.RunMode = Timer.RunModes.Single
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function LineEndingChar() As String
		  Return Encodings.UTF8.Chr(10)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub mUpdateTimer_Run(Sender As Timer)
		  #Pragma Unused Sender
		  
		  RaiseEvent UpdateUI
		  
		  If Self.mFinished Then
		    RaiseEvent Finished(Self.mParsedData)
		    Self.mParsedData = Nil
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Progress() As Double
		  Return Self.mCharactersProcessed / Self.mCharactersTotal
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function ToXojoType(Input As Variant) As Variant
		  If Input = Nil Then
		    Return Nil
		  End If
		  
		  If Input.IsArray And Input.ArrayElementType = Variant.TypeObject Then
		    Dim ArrayValue() As Variant = Input
		    Dim IsDict As Boolean = True
		    For Each Item As Variant In ArrayValue
		      IsDict = IsDict And Item.Type = Variant.TypeObject And Item.ObjectValue IsA Beacon.Pair
		    Next
		    If IsDict Then
		      Dim Dict As New Dictionary
		      For Each Item As Beacon.Pair In ArrayValue
		        Dict.Value(Item.Key) = ToXojoType(Item.Value)
		      Next
		      Return Dict
		    Else
		      Dim Items() As Variant
		      For Each Item As Variant In ArrayValue
		        Items.AddRow(ToXojoType(Item))
		      Next
		      Return Items
		    End If
		  End If
		  
		  Select Case Input.Type
		  Case Variant.TypeObject
		    Dim ObjectValue As Object = Input.ObjectValue
		    Select Case ObjectValue
		    Case IsA Beacon.Pair
		      Dim Original As Beacon.Pair = Input
		      Return New Beacon.Pair(Original.Key, ToXojoType(Original.Value))
		    End Select
		  Case Variant.TypeString
		    Dim StringValue As String = Input.StringValue
		    If StringValue = "true" Then
		      Return True
		    ElseIf StringValue = "false" Then
		      Return False
		    Else
		      Dim IsNumeric As Boolean = True
		      Dim DecimalPoints As Integer
		      Dim Characters() As String = StringValue.Split("")
		      For Each Char As String In Characters
		        Select Case Char
		        Case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"
		          // Still a Number
		        Case "."
		          If DecimalPoints = 1 Then
		            IsNumeric = False
		            Exit
		          Else
		            DecimalPoints = 1
		          End If
		        Else
		          IsNumeric = False
		          Exit
		        End Select
		      Next
		      If IsNumeric Then
		        // Number
		        Return Val(StringValue)
		      Else
		        // Probably String
		        Return StringValue
		      End If
		    End If
		  End Select
		End Function
	#tag EndMethod


	#tag Hook, Flags = &h0
		Event Finished(ParsedData As Dictionary)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event ThreadedParseFinished(ParsedData As Dictionary)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event UpdateUI()
	#tag EndHook


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return Self.mGameIniContent
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  If Self.ThreadState <> Thread.ThreadStates.NotRunning Then
			    Dim Err As New RuntimeException
			    Err.Reason = "Importer is already running"
			    Raise Err
			  End If
			  
			  Self.mGameIniContent = Value.GuessEncoding
			End Set
		#tag EndSetter
		GameIniContent As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return Self.mGameUserSettingsIniContent
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  If Self.ThreadState <> Thread.ThreadStates.NotRunning Then
			    Dim Err As New RuntimeException
			    Err.Reason = "Importer is already running"
			    Raise Err
			  End If
			  
			  Self.mGameUserSettingsIniContent = Value.GuessEncoding
			End Set
		#tag EndSetter
		GameUserSettingsIniContent As String
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private mCancelled As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mCharactersProcessed As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mCharactersTotal As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mFinished As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mGameIniContent As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mGameUserSettingsIniContent As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mParsedData As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mUpdateTimer As Timer
	#tag EndProperty


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
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Priority"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="StackSize"
			Visible=false
			Group="Behavior"
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
			Name="GameIniContent"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="GameUserSettingsIniContent"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
