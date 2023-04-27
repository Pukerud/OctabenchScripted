# This script runs the octane.exe benchmark tool with the output file test.txt.
# It then extracts the Total Score from the output file, appends it to benchmarks.txt, and deletes test.txt.

# Prompt the user to enter the number of times they want to run the benchmark.
$numberOfRuns = Read-Host -Prompt 'Enter the number of times you want to run the benchmark'

# Run the benchmark the specified number of times.
for ($i = 1; $i -le $numberOfRuns; $i++) {
    Write-Host "Running benchmark $i of $numberOfRuns"
    
    # Run the octane.exe with the -a flag to output to test.txt and wait for it to finish
    Start-Process -FilePath .\octane.exe -ArgumentList "-a test.txt" -NoNewWindow -Wait

    # Check if the test.txt file exists.
    if (Test-Path test.txt) {
        # Get the line number containing "Total score:"
        $lineNumber = (Select-String -Path test.txt -Pattern "Total score:").LineNumber

        # If the line containing "Total score:" is found, get the score from the next line.
        if ($lineNumber -ne $null) {
            $scoreLine = Get-Content -Path test.txt -TotalCount ($lineNumber + 1) | Select-Object -Last 1
            Add-Content -Path benchmarks.txt -Value "Run ${i}: $scoreLine"
            
            # Delete test.txt after extracting the score
            Remove-Item -Path test.txt
        } else {
            Write-Host "Total score not found in test.txt"
        }
    } else {
        Write-Host "test.txt not found"
    }
}

Write-Host "Benchmark(s) complete. Scores are saved in benchmarks.txt"
