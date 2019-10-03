#tag Class
Protected Class SetEntryOption
Implements Beacon.DocumentItem
	#tag Method, Flags = &h0
		Sub Constructor(Engram As Beacon.Engram, Weight As Double)
		  Self.mEngram = New Beacon.Engram(Engram)
		  Self.mWeight = Weight
		  Self.mLastModifiedTime = System.Microseconds
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(Source As Beacon.SetEntryOption)
		  Self.mEngram = New Beacon.Engram(Source.mEngram)
		  Self.mHash = Source.mHash
		  Self.mLastHashTime = Source.mLastHashTime
		  Self.mLastModifiedTime = Source.mLastModifiedTime
		  Self.mLastSaveTime = Source.mLastSaveTime
		  Self.mWeight = Source.mWeight
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ConsumeMissingEngrams(Engrams() As Beacon.Engram)
		  If Self.mEngram.IsValid Then
		    Return
		  End If
		  
		  Dim ClassString As String = Self.mEngram.ClassString
		  For Each Engram As Beacon.Engram In Engrams
		    If Engram.ClassString = ClassString Then
		      Self.mEngram = New Beacon.Engram(Engram)
		      Self.mLastModifiedTime = System.Microseconds
		      Return
		    End If
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Engram() As Beacon.Engram
		  Return New Beacon.Engram(Self.mEngram)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Export() As Dictionary
		  Dim Path As String = Self.Engram.Path
		  
		  Dim Keys As New Dictionary
		  If Path <> "" Then
		    Keys.Value("Path") = Path
		  End If
		  Keys.Value("Class") = Self.Engram.ClassString
		  Keys.Value("Weight") = Self.Weight
		  Return Keys
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Hash() As String
		  If Self.HashIsStale Then
		    Dim Path As String
		    If Self.mEngram = Nil Then
		      Path = ""
		    Else
		      Path = If(Self.mEngram.Path <> "", Self.mEngram.Path, Self.mEngram.ClassString)
		    End If
		    
		    Self.mHash = Beacon.MD5(Path.Lowercase + "@" + Self.mWeight.ToString(Locale.Raw, "0.0000")).Lowercase
		    Self.mLastHashTime = System.Microseconds
		  End If
		  
		  Return Self.mHash
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function HashIsStale() As Boolean
		  Return Self.mLastHashTime < Self.mLastModifiedTime
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function ImportFromBeacon(Dict As Dictionary) As Beacon.SetEntryOption
		  Dim Weight As Double = Dict.Value("Weight")
		  Dim Engram, BackupEngram As Beacon.Engram
		  
		  If Dict.HasKey("Path") Then
		    Engram = Beacon.Data.GetEngramByPath(Dict.Value("Path"))
		    If Engram = Nil Then
		      BackupEngram = Beacon.Engram.CreateUnknownEngram(Dict.Value("Path"))
		    End If
		  End If
		  
		  If Engram = Nil And Dict.HasKey("Class") Then
		    Engram = Beacon.Data.GetEngramByClass(Dict.Value("Class"))
		    If Engram = Nil And BackupEngram = Nil Then
		      BackupEngram = Beacon.Engram.CreateUnknownEngram(Dict.Value("Class"))
		    End If
		  End If
		  
		  If Engram = Nil Then
		    If BackupEngram = Nil Then
		      Return Nil
		    End If
		    Engram = BackupEngram
		  End If
		  
		  Dim Option As New Beacon.SetEntryOption(Engram, Weight)
		  Option.Modified = False
		  Return Option
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsValid(Document As Beacon.Document) As Boolean
		  Return Self.mEngram <> Nil And Self.mEngram.IsValid And (Document.Mods.LastRowIndex = -1 Or Document.Mods.IndexOf(Self.mEngram.ModID) > -1) And Self.mEngram.IsTagged("Generic") = False And Self.mEngram.IsTagged("Blueprint") = False
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Modified() As Boolean
		  Return Self.mLastModifiedTime > Self.mLastSaveTime
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Modified(Assigns Value As Boolean)
		  If Value = False Then
		    Self.mLastSaveTime = System.Microseconds
		  Else
		    Self.mLastModifiedTime = System.Microseconds
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Operator_Compare(Other As Beacon.SetEntryOption) As Integer
		  If Other = Nil Then
		    Return 1
		  End If
		  
		  Dim SelfHash As String = Self.Hash
		  Dim OtherHash As String = Other.Hash
		  
		  Return SelfHash.Compare(OtherHash, ComparisonOptions.CaseInsensitive)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Weight() As Double
		  Return Self.mWeight
		End Function
	#tag EndMethod


	#tag Property, Flags = &h21
		Private mEngram As Beacon.Engram
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mHash As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mLastHashTime As Double
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mLastModifiedTime As Double
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mLastSaveTime As Double
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mWeight As Double
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
	#tag EndViewBehavior
End Class
#tag EndClass
