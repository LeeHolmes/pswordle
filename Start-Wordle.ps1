$wordlist = Select-String "^[a-z]{5}$" $PSScriptRoot\allwords.txt
$word = Select-String "^[a-z]{5}$" $PSScriptRoot\commonwords.txt | Select -First 1000 | Get-Random

$guessCount = 1
$wordleShare = "","","","","","",""

while($true)
{
    $guess = Read-Host "`r`n($guessCount) Guess a 5-letter word"

    if($guess -eq $word.Line) { Write-Host "`r`nCorrect!"; $wordleShare[$guessCount - 1] = "🟩"*5; break }
    if($guess.Length -ne 5) { Write-Host "Guess must be 5 letters!" -NoNewLine; continue }
    if($guess -notin $wordList.Line) { Write-Host "Not a word!" -NoNewLine; continue }

    for($pos = 0; $pos -lt 5; $pos++)
    {
        $writeColor = "DarkGray"
        $shareImage = "⬜"

        if($guess[$pos] -eq $word.Line[$pos]) { $writeColor = "Green";  $shareImage = "🟩" }
        elseif(($guess[0..$pos] -eq $guess[$pos]).Count -le ($word.Line.ToCharArray() -eq $guess[$pos]).Count) { $writeColor = "Yellow"; $shareImage = "🟨" }

        Write-Host -Fore $writeColor $guess[$pos] -NoNewLine;
        $wordleShare[$guessCount - 1] += $shareImage 
    }

    if($guessCount++ -eq 6) { Write-Host "`r`n`r`nToo many guesses! Try again tomorrow! The right word was: '$($word.Line)'"; break }
}

Write-Host "PSWORDLE $($word.LineNumber) $guessCount/6`r`n"
$wordleShare[0..$guessCount]
