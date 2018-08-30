# PSNamedPipe

[![Build status](https://ci.appveyor.com/api/projects/status/u1sdo3sp3cxuf84u?svg=true)](https://ci.appveyor.com/project/MSAdministrator/psnamedpipe)

## PSNamedPipe Title

A PowerShell Module to create a Client and Server Named Pipe Server on Windows Systems

## Synopsis

A PowerShell Module to create a Client and Server Named Pipe Server on Windows Systems

## Description

A PowerShell Module to create a Client and Server Named Pipe Server on Windows Systems

## Using PSNamedPipe

To use this module, you will first need to download/clone the repository and import the module:

```powershell
Import-Module .\PSNamedPipe.psm1
```

### New-PSNamedPipeServer

Once imported, you will need to first create a new NamedPipe Server to send communications to the client

```powershell
New-PSNamedPipeServer -Name 'ps-namedpipe-server' -ComputerName '.' -Direction Out -MaxInstances 1 -Mode Message
```

### New-PSNamedPipeClient

After creating the new NamedPiped Server, we can create and connect to the server via the NamedPipe client

```powershell
New-PSNamedPipeClient -Name 'ps-namedpipe-server' -ComputerName '.' -Direction InOut
```

## Notes

```yaml
   Name: PSNamedPipe
   Created by: MSAdministrator
   Created Date: Thursday, August 30, 2018 12:36:43 AM
```