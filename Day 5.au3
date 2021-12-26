; ANSWER IS 4993
;should be experimented with for the purposes of figuring out how int types work.

#Region INCLUDES

#include <Excel.au3>
#include <Array.au3>
#include <Math.au3>

#EndRegion INCLUDES

#Region GLOBAL VARIABLES

$gc_sInputPath = "C:\Users\Radiators\Documents\AutoIT\inputs.xlsx"
$gc_sTestInputPath = "C:\Users\Radiators\Documents\AutoIT\TestInputs.xlsx"

#EndRegion GLOBAL VARIABLES

$oExcelApp = _Excel_Open(False)
$oWb = _Excel_BookOpen($oExcelApp, $gc_sInputPath)
$oWs = $oWb.worksheets(1)

$iLastRow = $oWs.UsedRange.Rows.Count

$aInputs = _Excel_RangeRead($oWb, $oWs, "A1:A" & $iLastRow)
_Excel_Close($oExcelApp)

; --- Input read in end

Local $aLineCoordinates[0][4] ;x1 y1 x2 y2

For $i = 0 To UBound($aInputs) - 1

	$sCoordinateString = StringReplace($aInputs[$i], " -> ", ",")

	_ArrayAdd($aLineCoordinates, $sCoordinateString, Default, ",")

Next

$ix1Max = int(_ArrayMax($aLineCoordinates, 1, Default, Default, 0))
$ix2Max = int(_ArrayMax($aLineCoordinates, 1, Default, Default, 2))
$iy1Max = int(_ArrayMax($aLineCoordinates, 1, Default, Default, 1))
$iy2Max = int(_ArrayMax($aLineCoordinates, 1, Default, Default, 3))

$iMaxColumn = _max($ix1Max,$ix2Max)
$iMaxRow = _Max($iy1Max,$iy2Max)

Local $aCoordinateMap[$iMaxRow + 1][$iMaxColumn + 1]
$iOverlapCounter = 0

For $i = 0 To UBound($aLineCoordinates) - 1

	$x1 = Int($aLineCoordinates[$i][0])
	$x2 = Int($aLineCoordinates[$i][2])
	$y1 = Int($aLineCoordinates[$i][1])
	$y2 = Int($aLineCoordinates[$i][3])

	If $x1 = $x2 Or $y1 = $y2 Then

		If $x1 <> $x2 Then

			$xSmaller = _Min($x1, $x2)
			$xBigger = _Max($x1, $x2)

			For $j = $xSmaller To $xBigger

				If $aCoordinateMap[$y1][$j] = 1 Then ;because y would then remain stationary for this function

					$iOverlapCounter += 1
					$aCoordinateMap[$y1][$j] = "Multiple"

				ElseIf $aCoordinateMap[$y1][$j] <> "Multiple" Then ;Means it's currently empty

					$aCoordinateMap[$y1][$j] = 1

				EndIf

			Next

		ElseIf $y1 <> $y2 Then

			$ySmaller = _Min($y1, $y2)
			$yBigger = _Max($y1, $y2)

			For $j = $ySmaller To $yBigger

				If $aCoordinateMap[$j][$x1] = 1 Then ;because x would then remain stationary for this function

					$iOverlapCounter += 1
					$aCoordinateMap[$j][$x1] = "Multiple"

				ElseIf $aCoordinateMap[$j][$x1] <> "Multiple" Then ;Means it's currently empty

					$aCoordinateMap[$j][$x1] = 1

				EndIf

			Next

		EndIf

	Else

		$iSteps = abs($x1 - $x2)
		$xTemp = $x1
		$yTemp = $y1

		If $aCoordinateMap[$yTemp][$xTemp] = 1 Then ;because x would then remain stationary for this function

			$iOverlapCounter += 1
			$aCoordinateMap[$yTemp][$xTemp] = "Multiple"

		ElseIf $aCoordinateMap[$yTemp][$xTemp] <> "Multiple" Then ;Means it's currently empty

			$aCoordinateMap[$yTemp][$xTemp] = 1

		EndIf

		for $j = 1 to $iSteps

			if $x1 < $x2 Then

				$xTemp += 1

			Else

				$xTemp -= 1

			EndIf

			if $y1 < $y2 Then

				$yTemp += 1

			Else

				$yTemp -= 1

			EndIf

			If $aCoordinateMap[$yTemp][$xTemp] = 1 Then ;because x would then remain stationary for this function

				$iOverlapCounter += 1
				$aCoordinateMap[$yTemp][$xTemp] = "Multiple"

			ElseIf $aCoordinateMap[$yTemp][$xTemp] <> "Multiple" Then ;Means it's currently empty

				$aCoordinateMap[$yTemp][$xTemp] = 1

			EndIf

		Next

	EndIf

Next

;~ _ArrayDisplay($aCoordinateMap)

MsgBox(0, 0, $iOverlapCounter)

#Region FUNCTIONS



#EndRegion FUNCTIONS
