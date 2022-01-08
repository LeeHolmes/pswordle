$wordlist = Select-String "^[a-z]{5}$" $PSScriptRoot\allwords.txt
$word = Select-String "^[a-z]{5}$" $PSScriptRoot\commonwords.txt | Select -First 1000 | Get-Random

$guessCount = 1
$wordleShare = "","","","","","",""

while($true)
{
    $guess = Read-Host "($guessCount) Guess a 5-letter word"

    if($guess -eq $word.Line) { Write-Host "Correct!"; $wordleShare[$guessCount] = "🟩"*5; break }
    if($guess.Length -ne 5) { Write-Host "Guess must be 5 letters!"; continue }
    if($guess -notin $wordList.Line) { Write-Host "Not a word!"; continue }

    for($pos = 0; $pos -lt 5; $pos++)
    {
        $shareImage = "⬜"
        if($guess[$pos] -eq $word.Line[$pos]) { Write-Host -Fore Green $guess[$pos] -NoNewLine; $shareImage = "🟩" }
        elseif($guess[$pos] -in $word.Line.ToCharArray()) { Write-Host -Fore Yellow $guess[$pos] -NoNewLine; $shareImage = "🟨" }
        else { Write-Host -Fore DarkGray "." -NoNewLine }

        $wordleShare[$guessCount - 1] += $shareImage 
    }

    $guessCount++
    if($guessCount -eq 7) { Write-Host; Write-Host "Too many guesses! Try again tomorrow! The right word was: '$($word.Line)'"; break }

    Write-Host
}

Write-Host

Write-Host "PSWORDLE $($word.LineNumber) $guessCount/6`r`n"
$wordleShare | ? { $_ }