Param(
	[Parameter(Mandatory)]
	[string]$Path1,
	[string]$Ext
)

$DefaultAlgorithm = '.sha256'
$DefaultAlgorithmShort = 'sha256'

$AlgorithmShortNames = @(
	'sha256'
	'md5'
	'sha1'
	'sfv'
)

$AlgorithmExts = @(
	'.sha256sum'
	'.md5'
	'.sha1'
	'.sfv'
)

$Path1Full
Try {
	Get-Item $Path1 -ErrorAction Stop | Out-Null
	$Path1Full = (Get-Item $Path1).FullName
} Catch 
{
	Write-Error "$Path1 Not found"
	Exit
}

$CurrentAlgorithm = $DefaultAlgorithm
$CurrentAlgorithmShort = $DefaultAlgorithmShort

for (($i = 0); ($i -lt $AlgorithmExts.Count); ($i++))
{
	If ($AlgorithmShortNames[$i].ToLower() -match $Ext.ToLower()) {
		$CurrentAlgorithm = $AlgorithmExts[$i]
		$CurrentAlgorithmShort = $AlgorithmShortNames[$i]
		break
	}
}

Try
{
	Get-Item ($Path1Full + $CurrentAlgorithm) -ErrorAction Stop | Out-Null
} Catch 
{
	Write-Error "$Path1$CurrentAlgorithm Not found"
	Exit
}

$Path1Hash = Get-FileHash -Path ($Path1Full) -Algorithm $CurrentAlgorithmShort
$ChecksumHash = Get-Content -Path ($Path1Full + $CurrentAlgorithm)

# Write-Host "Line 1: Calculated hash. Line 2: Checksum hash"
Write-Host $Path1Hash.Hash
Write-Host $ChecksumHash.ToUpper()
