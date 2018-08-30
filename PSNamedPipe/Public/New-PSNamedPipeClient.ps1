<#
.SYNOPSIS
    Creates a new Named Pipe client
.DESCRIPTION
    Creates a new NamedPipe client that can send or receive communications from a NamedPipe Server
.EXAMPLE Local machine NamedPipe Server Message Mode
    Create NamedPipe client on the local machine that can send communications to the server in Message mode
    
    New-PSNamedPipeServer -Name 'ps-namedpipe-server' -ComputerName '.' -Direction InOut
.EXAMPLE Local machine NamedPipe Client Byte Mode
    Create NamedPipe client on the local machine that can send communications to the server in Byte mode
    
    New-PSNamedPipeServer -Name 'ps-namedpipe-server' -ComputerName '.' -Direction InOut 
.EXAMPLE Remote machine NamedPipe Client Message Mode
    Create NamedPipe client on this machine and send communications to the remote NamedPipe server in Message mode
    
    New-PSNamedPipeServer -Name 'ps-namedpipe-server' -ComputerName 'DESKTOP-12345' -Direction InOut
.EXAMPLE Remote machine NamedPipe client Byte Mode
    Create NamedPipe client on this machine and send communications to the remote NamedPipe server in Byte mode
    
    New-PSNamedPipeServer -Name 'ps-namedpipe-server' -ComputerName 'DESKTOP-12345' -Direction InOut
#>
function New-PSNamedPipeClient {
    [CmdletBinding(DefaultParameterSetName = 'Parameter Set 1',
        PositionalBinding = $false,
        HelpUri = 'http://www.microsoft.com/',
        ConfirmImpact = 'Medium')]
    [Alias()]
    [OutputType([String])]
    Param (
        # Param1 help description
        [Parameter(Mandatory = $true,
            Position = 0,
            ValueFromPipelineByPropertyName = $true)]
        [string]$Name,
        
        # Param2 help description
        [Parameter(Mandatory = $true,
            Position = 1,
            ValueFromPipelineByPropertyName = $true)]
        [string]$ComputerName = '.',
        
        # Param3 help description
        [Parameter(Mandatory = $true,
            Position = 2,
            ValueFromPipelineByPropertyName = $true)]
        [ValidateSet("In", "Out", "InOut")]
        $Direction
    )
    
    $pipeClient = New-Object -TypeName System.IO.Pipes.NamedPipeClientStream -ArgumentList @(
        $ComputerName, $Name, $Direction)

    $pipeClient.Connect()
    $pipeClient.ReadMode = [System.IO.Pipes.PipeTransmissionMode]::Message

    $pipeBuffer = New-Object -TypeName System.Byte[] -ArgumentList 10000

    # read from the pipe
    $pipeCounter = $pipeClient.Read($pipeBuffer, 0, $pipeBuffer.count)

    # Trim off the unfilled portion of the buffer array.
    $pipeBuffer = $pipeBuffer[0..($pipeCounter - 1)]

    # Cast byte array into a character array, join into a single string, then print.
    [char[]] $pipeBuffer -join ""

    ## Optionally, you can read data from the pipe byte-by-byte instead.
    # $pipeclient.ReadMode = [System.IO.Pipes.PipeTransmissionMode]::Byte
    # $reader = new-object System.IO.StreamReader -arg @($pipeclient)
    # while (($temp = $reader.ReadLine()) -ne $null) { $temp + "`n" } 
}