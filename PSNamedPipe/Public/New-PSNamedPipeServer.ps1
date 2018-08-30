<#
.SYNOPSIS
    Creates a new Named Pipe Server
.DESCRIPTION
    Creates a new NamedPipe Server that can send or receive communications from a client
.EXAMPLE Local machine NamedPipe Server Message Mode
    Create NamedPipe Server on the local machine that can send communications to the client in Message mode
    
    New-PSNamedPipeServer -Name 'ps-namedpipe-server' -ComputerName '.' -Direction Out -MaxInstances 1 -Mode Message
.EXAMPLE Local machine NamedPipe Server Byte Mode
    Create NamedPipe Server on the local machine that can send communications to the client in Byte mode
    
    New-PSNamedPipeServer -Name 'ps-namedpipe-server' -ComputerName '.' -Direction Out -MaxInstances 1 -Mode Byte
.EXAMPLE Remote machine NamedPipe Server Message Mode
    Create NamedPipe Server on a remote machine that can send communications to the client in Message mode
    
    New-PSNamedPipeServer -Name 'ps-namedpipe-server' -ComputerName 'DESKTOP-12345' -Direction Out -MaxInstances 1 -Mode Message
.EXAMPLE Remote machine NamedPipe Server Byte Mode
    Create NamedPipe Server on a remote machine that can send communications to the client in Byte mode
    
    New-PSNamedPipeServer -Name 'ps-namedpipe-server' -ComputerName 'DESKTOP-12345' -Direction Out -MaxInstances 1 -Mode Byte
#>
function New-PSNamedPipeServer {
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
        $Direction,

        [Parameter(Mandatory = $true,
            Position = 3,
            ValueFromPipelineByPropertyName = $true)]
        [int]
        $MaxInstances = 1,

        [Parameter(Mandatory = $true,
            Position = 4,
            ValueFromPipelineByPropertyName = $true)]
        [ValidateSet("Byte", "Message")]
        $Mode
    )
    
    $pipeServer = New-Object -TypeName System.IO.Pipes.NamedPipeServerStream -ArgumentList @(
        $Name, $Direction, $MaxInstances, $Mode)

    $pipeServer.WaitForConnection() 

    # Write data to the pipe, to be read by the client.
    $writer = New-Object -TypeName System.IO.StreamWriter -ArgumentList @($pipeServer)
    $writer.AutoFlush = $true   #Flush buffer to stream after every Write().
    $writer.Write("This string was read from the pipe named " + $Name)

    # Now remove the named pipe and clean up.
    $pipeServer.Close()
}