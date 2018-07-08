###########Get-WinSvce Function#####################
Function Get-WinSvce {
   
   <#
	.SYNOPSIS
		This function help you to get needed details about any service, no matter how many computers, services or apply it on local machine or even remotely.
	
	.DESCRIPTION
		Use this function to bring any require informantion before execute service operations such as find stop service is applicable before stop it.
	
	.PARAMETER ComputerName
		Indicates the property to provide one computername or many .
	
	.PARAMETER ServiceName
		Indicates the property to provide one service name or many .

	
	.PARAMETER DisplayOptoins
		Indicates the property to call another function under name Get-WinSvceDisplayOptions to display service details based of your concern information.
	
	.PARAMETER Credential
		Indicates the property to call another function under name Get-WinSvceCredential and be able connect on computer with different credentials.
	
	.EXAMPLE
	    Get-WinSvce	-ComputerName Server1 -ServiceName W32Time

	.EXAMPLE
		Get-WinSvce	-ComputerName Server1,Server2 -ServiceName W32Time,Browser -DisplayOptoins
	
	.EXAMPLE
		Get-WinSvce	-ComputerName Server1 -ServiceName W32Time,Browser -DisplayOptoins -Credential
   #>
    
   param ($ComputerName,
           $ServiceName,
           [Switch]$DisplayOptoins,
           [Switch]$Credential)

   #Set trusted hosts
   Set-Item WSMan:\localhost\Client\TrustedHosts –Value “*” -ea 0 -Force
    
   #Get number of computers
    $WinSrvNumber=($ComputerName).count

   #Get service on one computer with credential
   if (($WinSrvNumber -eq 1) -and ($Credential -eq $true)){
        
                        
        #Call Get-WinSvceCredential function
        $WinCheckCred=1
        Get-WinSvceCredential
        
        #Get services based on function Get-WinSvceDisplayOptions
        if ($DisplayOptoins){
            
            #Call Function Get-WinSvceDisplayOptions
            $WinSvceProperty = Get-WinSvceDisplayOptions

            
            #Get services
            Write-Host ("Display services on computername: " + $ComputerName) -ForegroundColor Green

            #Foreach to include server type into service details if checked
            $WinGetSvc=@()
            foreach ($WinSvceTypeTemp in $ServiceName){
                 $WinGetSvc+=Invoke-Command -ComputerName $ComputerName -Credential $Global:WinCredential -ScriptBlock{Get-Service -Name $using:WinSvceTypeTemp} | Select-Object $WinSvceProperty
            } #end  foreach ($WinSvceTypeTemp in $ServiceName)

            #Display get services after choose concern display properties
            $WinGetSvc | Format-Table -Wrap -AutoSize
        } #end if ($DisplayOptoins)

        else{
        #get  service wtih default display options
        Write-Host ("Display services on computername: " + $ComputerName) -ForegroundColor Green
        Invoke-Command -ComputerName $ComputerName -Credential $Global:WinCredential -ScriptBlock{Get-Service -Name $using:ServiceName} | Format-Table -Property Status, Name, DisplayName -Wrap -AutoSize
        } #end else
    } #end if (($WinSrvNumber -eq 1) -and ($Credential -eq $true))

            
   #Get service on one computer without credential
   if (($WinSrvNumber -eq 1) -and ($Credential -eq $false)){

        #Referance value to Get-Global:WinCredential function
        $WinCheckCred=0
        
        #Get services based on function Get-WinSvceDisplayOptions
        if ($DisplayOptoins){
            
            #Call Function Get-WinSvceDisplayOptions
            $WinSvceProperty = Get-WinSvceDisplayOptions

            
            #Get services
            Write-Host ("Display services on computername: " + $ComputerName) -ForegroundColor Green

            #Foreach to include server type into service details if checked
            $WinGetSvc=@()
            foreach ($WinSvceTypeTemp in $ServiceName){
                 $WinGetSvc+=Invoke-Command -ComputerName $ComputerName -ScriptBlock{Get-Service -Name $using:WinSvceTypeTemp} | Select-Object $WinSvceProperty
            } #end  foreach ($WinSvceTypeTemp in $ServiceName)

            #Display get services after choose concern display properties
            $WinGetSvc | Format-Table -Wrap -AutoSize
        } #end if ($DisplayOptoins)

        else{
        #get  service wtih default display options
        Write-Host ("Display services on computername: " + $ComputerName) -ForegroundColor Green
        Invoke-Command -ComputerName $ComputerName -ScriptBlock{Get-Service -Name $using:ServiceName} | Format-Table -Property Status, Name, DisplayName -Wrap -AutoSize
        } #end else
    } #end if (($WinSrvNumber -eq 1) -and ($Credential -eq $false))


   #Get service on multi computer with credentail
   if (($WinSrvNumber -gt 1) -and ($Credential -eq $true)){

        #Call Get-WinSvceCredential function
        $WinCheckCred=1
        Get-WinSvceCredential

        #Get services based on function Get-WinSvceDisplayOptions
        if ($DisplayOptoins){
             #Call Function Get-WinSvceDisplayOptions
             $WinSvceProperty = Get-WinSvceDisplayOptions  
                  
             #Connect to each computer
             for ($counter=0; $counter -lt $WinSrvNumber; $counter++){
                  #Get services
                  Write-Host ("Display services on computername: " + $ComputerName[$counter]) -ForegroundColor Green
          
                  #Foreach to include server type into service details if checked
                  $WinGetSvc=@()
                  foreach ($WinSvceTypeTemp in $ServiceName){
                  $WinGetSvc+=Invoke-Command -ComputerName $ComputerName[$counter] -Credential $Global:WinCredential -ScriptBlock{Get-Service -Name $using:WinSvceTypeTemp} | Select-Object $WinSvceProperty
                  } #end  foreach ($WinSvceTypeTemp in $ServiceName)

                  #Display get services after choose concern display properties
                  $WinGetSvc | Format-Table -Wrap -AutoSize

             } #end for ($counter=0; $counter -lt $WinSrvNumber; $counter)
        } #end if ($DisplayOptoins)

        else{
            #Connect to each computer
            for ($counter=0; $counter -lt $WinSrvNumber; $counter++){
                  #Get services
                  Write-Host ("Display services on computername: " + $ComputerName[$counter]) -ForegroundColor Green
                  Invoke-Command -ComputerName $ComputerName[$counter] -Credential $Global:WinCredential -ScriptBlock{Get-Service -Name $using:ServiceName} | Format-Table -Property Status, Name, DisplayName -Wrap -AutoSize
            } #end for ($counter=0; $counter -lt $WinSrvNumber; $counter)
        } #end else
    } #end if (($WinSrvNumber -gt 1) -and ($Credential -eq $true))


   #Get service on multi computer without credentail
   if (($WinSrvNumber -gt 1) -and ($Credential -eq $false)){

        #Referance value to Get-Global:WinCredential function
        $WinCheckCred=0

        #Get services based on function Get-WinSvceDisplayOptions
        if ($DisplayOptoins){

             #Call Function Get-WinSvceDisplayOptions
             $WinSvceProperty = Get-WinSvceDisplayOptions  
                  
             #Connect to each computer
             for ($counter=0; $counter -lt $WinSrvNumber; $counter++){
                  #Get services
                  Write-Host ("Display services on computername: " + $ComputerName[$counter]) -ForegroundColor Green
          
                  #Foreach to include server type into service details if checked
                  $WinGetSvc=@()
                  foreach ($WinSvceTypeTemp in $ServiceName){
                  $WinGetSvc+=Invoke-Command -ComputerName $ComputerName[$counter] -ScriptBlock{Get-Service -Name $using:WinSvceTypeTemp} | Select-Object $WinSvceProperty
                  } #end  foreach ($WinSvceTypeTemp in $ServiceName)

                  #Display get services after choose concern display properties
                  $WinGetSvc | Format-Table -Wrap -AutoSize

             } #end for ($counter=0; $counter -lt $WinSrvNumber; $counter)
        } #end if ($DisplayOptoins)

        else{
            #Connect to each computer
            for ($counter=0; $counter -lt $WinSrvNumber; $counter++){
                  #Get services
                  Write-Host ("Display services on computername: " + $ComputerName[$counter]) -ForegroundColor Green
                  Invoke-Command -ComputerName $ComputerName[$counter] -ScriptBlock{Get-Service -Name $using:ServiceName} | Format-Table -Property Status, Name, DisplayName -Wrap -AutoSize
            } #end for ($counter=0; $counter -lt $WinSrvNumber; $counter)
        } #end else
    } #end if (($WinSrvNumber -gt 1) -and ($Credential -eq $false))

   #Remove trusted hosts
   Clear-Item WSMan:\localhost\Client\TrustedHosts -Force

} #end Function Get-WinSvce


###########Get-WinSvceCredential Function###########
Function Get-WinSvceCredential {

    <#
	.SYNOPSIS
		This function used by other functions to get crednetial and be able conenct to computer with different authentication.
    #>


    $Global:WinCredential=Get-Credential -Credential 'Administrator'

} #end Function Get-WinSvceCredential


##########Get-WinSvceDisplayOptions Function########
Function Get-WinSvceDisplayOptions{

    <#
	.SYNOPSIS
		This function used by another function to get service display options.
    #>


    #region Import the Assemblies
    [void][reflection.assembly]::Load('System.Windows.Forms, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
	[void][reflection.assembly]::Load('System.Data, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
	[void][reflection.assembly]::Load('System.Drawing, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')

    #Get service form
    $formServiceDisplayOption = New-Object 'System.Windows.Forms.Form'
    $formServiceDisplayOption.AutoScaleDimensions = '6, 13'
    $formServiceDisplayOption.AutoScaleMode = 'Font'
    $formServiceDisplayOption.ClientSize = '371, 220'
    $formServiceDisplayOption.Name = 'formServiceDisplayOption'
    $formServiceDisplayOption.Text = 'Service Display Options'

    #Create require service option label
    $labelChooseRequireService = New-Object 'System.Windows.Forms.Label'
    $labelChooseRequireService.AutoSize = $True
    $labelChooseRequireService.Font = 'Microsoft Sans Serif, 8.25pt, style=Bold'
    $labelChooseRequireService.Location = '9, 16'
    $labelChooseRequireService.Name = 'labelChooseRequireService'
    $labelChooseRequireService.Size = '352, 13'
    $labelChooseRequireService.TabIndex = 11
    $labelChooseRequireService.Text = 'Choose require service informations would you like to display'

    #Create ok button
    $buttonOk = New-Object 'System.Windows.Forms.Button'
    $buttonOk.DialogResult = '1'
    $buttonOk.Location = '232, 45'
    $buttonOk.Name = 'buttonOk'
    $buttonOk.Size = '129, 34'
    $buttonOk.TabIndex = 9
    $buttonOk.Text = 'Ok'
    $buttonOk.UseVisualStyleBackColor = $True

    #Create cancel button
    $buttonCancel = New-Object 'System.Windows.Forms.Button'
    $buttonCancel.DialogResult = 'Cancel'
    $buttonCancel.Location = '232, 89'
    $buttonCancel.Name = 'buttonCancel'
    $buttonCancel.Size = '129, 33'
    $buttonCancel.TabIndex = 10
    $buttonCancel.Text = 'Cancel'
    $buttonCancel.UseVisualStyleBackColor = $True
   
    #Create check all button
    $buttonCheckAll = New-Object 'System.Windows.Forms.Button'
    $buttonCheckAll.DialogResult = 'None'
    $buttonCheckAll.Location = '232, 134'
    $buttonCheckAll.Name = 'buttonCheckAll'
    $buttonCheckAll.Size = '129, 33'
    $buttonCheckAll.TabIndex = 11
    $buttonCheckAll.Text = 'Check all'
    $buttonCheckAll.UseVisualStyleBackColor = $True
    $buttonCheckAll.Add_Click({CheckAll})

    #Create uncheck all button
    $buttonUncheckAll = New-Object 'System.Windows.Forms.Button'
    $buttonUncheckAll.DialogResult = 'None'
    $buttonUncheckAll.Location = '232, 178'
    $buttonUncheckAll.Name = 'buttonUncheckAll'
    $buttonUncheckAll.Size = '129, 33'
    $buttonUncheckAll.TabIndex = 12
    $buttonUncheckAll.Text = 'Uncheck all'
    $buttonUncheckAll.UseVisualStyleBackColor = $True
    $buttonUncheckAll.Add_Click({UnCheckAll})


    #Create status checkbox
    $checkboxSvceStatus = New-Object 'System.Windows.Forms.CheckBox'
    $checkboxSvceStatus.Font = 'Microsoft Tai Le, 8.25pt, style=Bold'
    $checkboxSvceStatus.Location = '12, 34'
    $checkboxSvceStatus.Name = 'checkboxSvceStatus'
    $checkboxSvceStatus.Size = '126, 24'
    $checkboxSvceStatus.TabIndex = 1
    $checkboxSvceStatus.Text = 'Service Status'
    $checkboxSvceStatus.UseVisualStyleBackColor = $True
    $checkboxSvceStatus.add_CheckedChanged($CheckboxSvceStatus_CheckedChanged)
    $formServiceDisplayOption.ResumeLayout()

    #Create require services checkbox
    $checkboxSvceRequiredServices = New-Object 'System.Windows.Forms.CheckBox'
    $checkboxSvceRequiredServices.Font = 'Microsoft Sans Serif, 8.25pt, style=Bold'
    $checkboxSvceRequiredServices.Location = '12, 55'
    $checkboxSvceRequiredServices.Name = 'checkboxSvceRequiredServices'
    $checkboxSvceRequiredServices.Size = '137, 24'
    $checkboxSvceRequiredServices.TabIndex = 2
    $checkboxSvceRequiredServices.Text = 'Required Services'
    $checkboxSvceRequiredServices.UseVisualStyleBackColor = $True

    #Create dependent services checkbox
    $checkboxSvceDependentServices = New-Object 'System.Windows.Forms.CheckBox'
    $checkboxSvceDependentServices.Font = 'Microsoft Sans Serif, 8.25pt, style=Bold'
    $checkboxSvceDependentServices.Location = '12, 75'
    $checkboxSvceDependentServices.Name = 'checkboxSvceDependentServices'
    $checkboxSvceDependentServices.Size = '148, 24'
    $checkboxSvceDependentServices.TabIndex = 3
    $checkboxSvceDependentServices.Text = 'Dependent Services'
    $checkboxSvceDependentServices.UseVisualStyleBackColor = $True

    #Create can pause and continue checkbox
    $checkboxSvceCanPauseAndContinue = New-Object 'System.Windows.Forms.CheckBox'
    $checkboxSvceCanPauseAndContinue.Font = 'Microsoft Sans Serif, 8.25pt, style=Bold'
    $checkboxSvceCanPauseAndContinue.Location = '12, 96'
    $checkboxSvceCanPauseAndContinue.Name = 'checkboxSvceCanPauseAndContinue'
    $checkboxSvceCanPauseAndContinue.Size = '181, 24'
    $checkboxSvceCanPauseAndContinue.TabIndex = 4
    $checkboxSvceCanPauseAndContinue.Text = 'Can Pause And Continue'
    $checkboxSvceCanPauseAndContinue.UseVisualStyleBackColor = $True

    #Create can stop checkbox
    $checkboxSvceCanStop = New-Object 'System.Windows.Forms.CheckBox'
    $checkboxSvceCanStop.Font = 'Microsoft Sans Serif, 8.25pt, style=Bold'
    $checkboxSvceCanStop.Location = '12, 117'
    $checkboxSvceCanStop.Name = 'checkboxSvceCanStop'
    $checkboxSvceCanStop.Size = '181, 24'
    $checkboxSvceCanStop.TabIndex = 5
    $checkboxSvceCanStop.Text = 'Can Stop'
    $checkboxSvceCanStop.UseVisualStyleBackColor = $True

    #Create start type checkbox
    $checkboxSvceStartType = New-Object 'System.Windows.Forms.CheckBox'
    $checkboxSvceStartType.Font = 'Microsoft Sans Serif, 8.25pt, style=Bold'
    $checkboxSvceStartType.Location = '12, 138'
    $checkboxSvceStartType.Name = 'checkboxSvceStartType'
    $checkboxSvceStartType.Size = '181, 24'
    $checkboxSvceStartType.TabIndex = 6
    $checkboxSvceStartType.Text = 'Start Type'
    $checkboxSvceStartType.UseVisualStyleBackColor = $True

    #Create name checkbox
    $checkboxSvceName = New-Object 'System.Windows.Forms.CheckBox'
    $checkboxSvceName.Font = 'Microsoft Sans Serif, 8.25pt, style=Bold'
    $checkboxSvceName.Location = '12, 159'
    $checkboxSvceName.Name = 'checkboxSvceName'
    $checkboxSvceName.Size = '181, 24'
    $checkboxSvceName.TabIndex = 7
    $checkboxSvceName.Text = 'Name'
    $checkboxSvceName.UseVisualStyleBackColor = $True

    #Create display name checkbox
    $checkboxSvceDisplayName = New-Object 'System.Windows.Forms.CheckBox'
    $checkboxSvceDisplayName.Font = 'Microsoft Sans Serif, 8.25pt, style=Bold'
    $checkboxSvceDisplayName.Location = '12, 180'
    $checkboxSvceDisplayName.Name = 'checkboxSvceDisplayName'
    $checkboxSvceDisplayName.Size = '181, 24'
    $checkboxSvceDisplayName.TabIndex = 8
    $checkboxSvceDisplayName.Text = 'Display Name'
    $checkboxSvceDisplayName.UseVisualStyleBackColor = $True

    #Add objects to form
    $formServiceDisplayOption.Controls.Add($labelChooseRequireService)
    $formServiceDisplayOption.Controls.Add($buttonOk)
    $formServiceDisplayOption.Controls.Add($buttonCancel)
    $formServiceDisplayOption.Controls.Add($buttonCheckAll)
    $formServiceDisplayOption.Controls.Add($buttonUncheckAll)
    $formServiceDisplayOption.Controls.Add($checkboxSvceStatus)
    $formServiceDisplayOption.Controls.Add($checkboxSvceRequiredServices)
    $formServiceDisplayOption.Controls.Add($checkboxSvceDependentServices)
    $formServiceDisplayOption.Controls.Add($checkboxSvceCanPauseAndContinue)
    $formServiceDisplayOption.Controls.Add($checkboxSvceCanStop)
    $formServiceDisplayOption.Controls.Add($checkboxSvceStartType)
    $formServiceDisplayOption.Controls.Add($checkboxSvceName)
    $formServiceDisplayOption.Controls.Add($checkboxSvceDisplayName)


    #Functoin to checll all service display options
    Function CheckAll{
        if ($buttonCheckAll.DialogResult -eq 'None'){
            $checkboxSvceStatus.Checked = $True
            $checkboxSvceRequiredServices.Checked = $True
            $checkboxSvceDependentServices.Checked = $True
            $checkboxSvceCanPauseAndContinue.Checked = $True
            $checkboxSvceCanStop.Checked = $True
            $checkboxSvceStartType.Checked = $True
            $checkboxSvceName.Checked = $True
            $checkboxSvceDisplayName.Checked = $True
        } #end if ($buttonCheckAll.DialogResult -eq 'None')
    } #end Function CheckAll


    #Functoin to unchecll all service display options
    Function UnCheckAll{
        if ($buttonCheckAll.DialogResult -eq 'None'){
            $checkboxSvceStatus.Checked = $False
            $checkboxSvceRequiredServices.Checked = $False
            $checkboxSvceDependentServices.Checked = $False
            $checkboxSvceCanPauseAndContinue.Checked = $False
            $checkboxSvceCanStop.Checked = $False
            $checkboxSvceStartType.Checked = $False
            $checkboxSvceName.Checked = $False
            $checkboxSvceDisplayName.Checked = $False
        } #end if ($buttonCheckAll.DialogResult -eq 'None')
    } #end Function UnCheckAll

    #Show the Form
    $formServiceDisplayOption.ShowDialog() | Out-Null

    
    #Add service display options to array
    $WinSvceOptions=@()

    if ($checkboxSvceStatus.Checked){
         $WinSvceOptions+='Status'
    } #end if ($checkboxSvceStatus.Checked)

    if ($checkboxSvceRequiredServices.Checked){
         $WinSvceOptions+=@{Label='RequiredServices'; Expression={($_.RequiredServices) -join "`n"}}
    } #end if ($checkboxSvceRequiredServices.Checked)

    if ($checkboxSvceDependentServices.Checked){
         $WinSvceOptions+=@{Label='DependentServices'; Expression={($_.DependentServices) -join "`n"}}
    } #end if ($checkboxSvceDependentServices.Checked)

    if ($checkboxSvceCanPauseAndContinue.Checked){
         $WinSvceOptions+='CanPauseAndContinue'
    } #end if ($checkboxSvceCanPauseAndContinue.Checked)

    if ($checkboxSvceCanStop.Checked){
         $WinSvceOptions+='CanStop'
    } #end if ($checkboxSvceCanStop.Checked)


    #StartType checkbox for one computer
    if (($WinSrvNumber -eq 1) -and ($WinCheckCred -eq 1)){
        if ($checkboxSvceStartType.Checked){
             $WinSvceOptions+=@{Label='StartType'; Expression={Invoke-Command -ComputerName $ComputerName -Credential $Global:WinCredential -ScriptBlock{(Get-CimInstance Win32_Service | ?{$_.name -match $using:WinSvceTypeTemp}).StartMode}}}
        } #end if ($checkboxSvceStartType.Checked)
    } #end if (($WinSrvNumber -eq 1) -and ($WinCheckCred -eq 1))
    elseif (($WinSrvNumber -eq 1) -and ($WinCheckCred -eq 0)){
        if ($checkboxSvceStartType.Checked){
             $WinSvceOptions+=@{Label='StartType'; Expression={Invoke-Command -ComputerName $ComputerName -ScriptBlock{(Get-CimInstance Win32_Service | ?{$_.name -match $using:WinSvceTypeTemp}).StartMode}}}
        } #end if ($checkboxSvceStartType.Checked)
    } #end elseif (($WinSrvNumber -eq 1) -and ($WinCheckCred -eq 0))

    #StartType checkbox for multi computer
    if (($WinSrvNumber -gt 1) -and ($WinCheckCred -eq 1)){
        if ($checkboxSvceStartType.Checked){
             $WinSvceOptions+=@{Label='StartType'; Expression={Invoke-Command -ComputerName $ComputerName[$counter] -Credential $Global:WinCredential -ScriptBlock{(Get-CimInstance Win32_Service | ?{$_.name -match $using:WinSvceTypeTemp}).StartMode}}}
        } #end if ($checkboxSvceStartType.Checked)
    } #end if (($WinSrvNumber -gt 1) -and ($WinCheckCred -eq 1))
    elseif (($WinSrvNumber -gt 1) -and ($WinCheckCred -eq 0)){
        if ($checkboxSvceStartType.Checked){
             $WinSvceOptions+=@{Label='StartType'; Expression={Invoke-Command -ComputerName $ComputerName[$counter] -ScriptBlock{(Get-CimInstance Win32_Service | ?{$_.name -match $using:WinSvceTypeTemp}).StartMode}}}
        } #end if ($checkboxSvceStartType.Checked)
    } #end elseif (($WinSrvNumber -gt 1) -and ($WinCheckCred -eq 0))

    if ($checkboxSvceName.Checked){
         $WinSvceOptions+='Name'
    } #end if ($checkboxSvceName.Checked)

    if ($checkboxSvceDisplayName.Checked){
         $WinSvceOptions+='DisplayName'
    } #end if ($checkboxSvceDisplayName.Checked)
      
    #Output service display options
    $WinSvceOptions
} #end Functoin Get-WinSvceDisplayOptions


###############Start-WinSvce Function################
Function Start-WinSvce {
    
    <#
	.SYNOPSIS
		This function help you to start needed service, no matter how many computers, services or apply it on local machine or even remotely.
	
	.DESCRIPTION
		Use this function to control start services, also it can bring up all required services as prerequisite before run mentioned service. 

	.PARAMETER ComputerName
		Indicates the property to provide one computername or many .
	
	.PARAMETER ServiceName
		Indicates the property to provide one service name or many .

	
	.PARAMETER RequiredService
		Indicates the property to get and run required services where mentioned service depend on them before start .
	
	.PARAMETER Credential
		Indicates the property to call another function under name Get-WinSvceCredential and be able connect on computer with different credentials.
	
	.EXAMPLE
	    Start-WinSvce -ComputerName Server1 -ServiceName W32Time

	.EXAMPLE
		Get-WinSvce	-ComputerName Server1,Server2 -ServiceName W32Time,iphlpsvc -RequiredService
	
	.EXAMPLE
		Get-WinSvce	-ComputerName Server1 -ServiceName W32Time,iphlpsvc -RequiredService -Credential
   #>

    param ($ComputerName,
           $ServiceName,
           [Switch]$RequiredService,
           [Switch]$Credential
           )

    #Set trusted hosts
    Set-Item WSMan:\localhost\Client\TrustedHosts –Value “*” -ea 0 -Force

    #Get number of computers
    $WinSrvNumber=($ComputerName).count
            
    #Run service on one computer with credential
    if (($WinSrvNumber -eq 1) -and ($Credential -eq $true)){

        #Call Get-WinSvceCredential function
        Get-WinSvceCredential
        
        #At begin run required services
        if ($RequiredService){
    
            #Get required services
            $WinGetSvcDepedning=Invoke-Command -ComputerName $ComputerName -Credential $Global:WinCredential -ScriptBlock{Get-Service -Name $using:ServiceName}
            $WinArraySvcDepnding=$WinGetSvcDepedning.RequiredServices | Sort-Object -Unique
   
            Write-Host ("At begin it must run required services on computername: " + $ComputerName) -ForegroundColor Green 

            #Run required services
            $WinGetSvceList=@()
            Foreach ($WinSvceDependTemp in $WinArraySvcDepnding) {
              Invoke-Command -ComputerName $ComputerName -Credential $Global:WinCredential -ScriptBlock{Start-Service -Name $using:WinSvceDependTemp}
              $WinGetSvceList+=Invoke-Command -ComputerName $ComputerName -Credential $Global:WinCredential -ScriptBlock{Get-Service -Name $using:WinSvceDependTemp}
            } #end foreach ($WinSvceDependTemp in $WinArraySvcDepnding)

            $WinGetSvceList | Format-Table -Property Status, Name, DisplayName -Wrap -AutoSize
            Start-Sleep -Milliseconds 3000
        } #end if ($RequiredService)

        #Run mentioned service
        Write-Host ("Run needed services on computername: " + $ComputerName) -ForegroundColor Green
        Invoke-Command -ComputerName $ComputerName -Credential $Global:WinCredential -ScriptBlock{Start-Service -Name $using:ServiceName}
        Invoke-Command -ComputerName $ComputerName -Credential $Global:WinCredential -ScriptBlock{Get-Service -Name $using:ServiceName} | Format-Table -Property Status, Name, DisplayName -Wrap -AutoSize
    } #end if (($WinSrvNumber -eq 1) -and ($Credential -eq $true))

    #Run service on one computer without credential
    if (($WinSrvNumber -eq 1) -and ($Credential -eq $false)){
        
        #At begin run required services
        if ($RequiredService){
    
            #Get required services
            $WinGetSvcDepedning=Invoke-Command -ComputerName $ComputerName -ScriptBlock{Get-Service -Name $using:ServiceName}
            $WinArraySvcDepnding=$WinGetSvcDepedning.RequiredServices | Sort-Object -Unique
   
            Write-Host ("At begin it must run required services on computername: " + $ComputerName) -ForegroundColor Green 

            #Run required services
            $WinGetSvceList=@()
            Foreach ($WinSvceDependTemp in $WinArraySvcDepnding) {
              Invoke-Command -ComputerName $ComputerName -ScriptBlock{Start-Service -Name $using:WinSvceDependTemp}
              $WinGetSvceList+=Invoke-Command -ComputerName $ComputerName -ScriptBlock{Get-Service -Name $using:WinSvceDependTemp}
            } #end foreach ($WinSvceDependTemp in $WinArraySvcDepnding)

            $WinGetSvceList | Format-Table -Property Status, Name, DisplayName -Wrap -AutoSize
            Start-Sleep -Milliseconds 3000
        } #end if ($RequiredService)

        #Run mentioned service
        Write-Host ("Run needed services on computername: " + $ComputerName) -ForegroundColor Green
        Invoke-Command -ComputerName $ComputerName -ScriptBlock{Start-Service -Name $using:ServiceName}
        Invoke-Command -ComputerName $ComputerName -ScriptBlock{Get-Service -Name $using:ServiceName} | Format-Table -Property Status, Name, DisplayName -Wrap -AutoSize
    } #end if (($WinSrvNumber -eq 1) -and ($Credential -eq $false))

    # Run service on multi computer with credential
    if (($WinSrvNumber -gt 1) -and ($Credential -eq $true)){
         
         #Call Get-WinSvceCredential function
         Get-WinSvceCredential
            
         #Connect to each computer
         for ($counter=0; $counter -lt $WinSrvNumber; $counter++){
            
            #At begin run required services
            if ($RequiredService){
                #get required services
                $WinArraySvcDepnding=$null

                $WinGetSvcDepedingSrv=Invoke-Command -ComputerName $ComputerName[$counter] -Credential $Global:WinCredential -ScriptBlock{Get-Service -Name $using:ServiceName}
                $WinArraySvcDepnding=$WinGetSvcDepedingSrv.RequiredServices | Sort-Object -Unique
                Write-Host ("At begin it must run required services on computername: " + $ComputerName[$counter]) -ForegroundColor Green

                #Run required services
                $WinGetSvceList=@()
                Foreach ($WinSvceDependTemp in $WinArraySvcDepnding) {
                  Invoke-Command -ComputerName $ComputerName[$counter] -Credential $Global:WinCredential -ScriptBlock{Start-Service -Name $using:WinSvceDependTemp}
                  $WinGetSvceList+=Invoke-Command -ComputerName $ComputerName[$counter] -Credential $Global:WinCredential -ScriptBlock{Get-Service -Name $using:WinSvceDependTemp}
                } #end foreach ($WinSvceDependTemp in $WinArraySvcDepnding)
          
                  $WinArraySvcDepnding=$null
                  $WinGetSvceList | Format-Table -Property Status, Name, DisplayName -Wrap -AutoSize
                  Start-Sleep -Milliseconds 3000
            } #end if ($RequiredService)

            #Run mentioned service
             Write-Host ("Run needed services on computername: " + $ComputerName[$counter]) -ForegroundColor Green
             Invoke-Command -ComputerName $ComputerName[$counter] -Credential $Global:WinCredential -ScriptBlock{Start-Service -Name $using:ServiceName}
             Invoke-Command -ComputerName $ComputerName[$counter] -Credential $Global:WinCredential -ScriptBlock{Get-Service -Name $using:ServiceName} | Format-Table -Property Status, Name, DisplayName -Wrap -AutoSize

        } #end for ($counter=0; $counter -lt $WinSrvNumber; $counter)
    } #end if (($WinSrvNumber -gt 1) -and ($Credential -eq $true)) 
    
    # Run service on multi computer without credential
    if (($WinSrvNumber -gt 1) -and ($Credential -eq $false)){
    
         #Connect to each computer
         for ($counter=0; $counter -lt $WinSrvNumber; $counter++){
            
            #At begin run required services
            if ($RequiredService){
                #get required services
                $WinArraySvcDepnding=$null

                $WinGetSvcDepedingSrv=Invoke-Command -ComputerName $ComputerName[$counter] -ScriptBlock{Get-Service -Name $using:ServiceName}
                $WinArraySvcDepnding=$WinGetSvcDepedingSrv.RequiredServices | Sort-Object -Unique
                Write-Host ("At begin it must run required services on computername: " + $ComputerName[$counter]) -ForegroundColor Green

                #Run required services
                $WinGetSvceList=@()
                Foreach ($WinSvceDependTemp in $WinArraySvcDepnding) {
                  Invoke-Command -ComputerName $ComputerName[$counter] -ScriptBlock{Start-Service -Name $using:WinSvceDependTemp}
                  $WinGetSvceList+=Invoke-Command -ComputerName $ComputerName[$counter] -ScriptBlock{Get-Service -Name $using:WinSvceDependTemp}
                } #end foreach ($WinSvceDependTemp in $WinArraySvcDepnding)
          
                  $WinArraySvcDepnding=$null
                  $WinGetSvceList | Format-Table -Property Status, Name, DisplayName -Wrap -AutoSize
                  Start-Sleep -Milliseconds 3000
            } #end if ($RequiredService)

            #Run mentioned service
             Write-Host ("Run needed services on computername: " + $ComputerName[$counter]) -ForegroundColor Green
             Invoke-Command -ComputerName $ComputerName[$counter] -ScriptBlock{Start-Service -Name $using:ServiceName}
             Invoke-Command -ComputerName $ComputerName[$counter] -ScriptBlock{Get-Service -Name $using:ServiceName} | Format-Table -Property Status, Name, DisplayName -Wrap -AutoSize

        } #end for ($counter=0; $counter -lt $WinSrvNumber; $counter)
    } #end if (($WinSrvNumber -gt 1) -and ($Credential -eq $false))

   #Remove trusted hosts
   Clear-Item WSMan:\localhost\Client\TrustedHosts -Force
           
} #end Function Start-WinSvce


###############Stop-WinSvce Function################
Function Stop-WinSvce {

    <#
	.SYNOPSIS
		This function help you to stop needed service, no matter how many computers, services or apply it on local machine or even remotely.
	
	.DESCRIPTION
		Use this function to manage stop services, also it can bring and stop dependent services before shutdown mentioned service. 

	.PARAMETER ComputerName
		Indicates the property to provide one computername or many .
	
	.PARAMETER ServiceName
		Indicates the property to provide one service name or many .
	
	.PARAMETER DependentServices
		Indicates the property to find dependent services to be stopped before shutdown mentioned service by call another function name Stop-WinSvceCanStop to collect only services can stop into array.
	
	.PARAMETER Credential
		Indicates the property to call another function under name Get-WinSvceCredential and be able connect on computer with different credentials.
	
	.EXAMPLE
	    Stop-WinSvce -ComputerName Server1 -ServiceName W32Time

	.EXAMPLE
		Stop-WinSvce -ComputerName Server1,Server2 -ServiceName W32Time,KeyIso -DependentServices
	
	.EXAMPLE
		Stop-WinSvce -ComputerName Server1 -ServiceName W32Time,KeyIso -DependentServices -Credential
   #>


    param ($ComputerName,
           $ServiceName,
           [Switch]$DependentServices,
           [Switch]$Credential  
           )

    #Set trusted hosts
    Set-Item WSMan:\localhost\Client\TrustedHosts –Value “*” -ea 0 -Force

    #Get number of computers
    $WinSrvNumber=($ComputerName).count

    #Stop service on one computer with credential
    if (($WinSrvNumber -eq 1) -and ($Credential -eq $true)){

        #Call Get-WinSvceCredential function
         Get-WinSvceCredential
        $Global:WinSvceCredential=1
        
        #Call Function Stop-WinSvceCanStop 
        Stop-WinSvceCanStop -ComputerName $ComputerName -ServiceName $ServiceName -Credential $Global:WinCredential 
        $WinSvcFinal=@($Global:ServiceNameCanStop) 

        #At begin stop depending services
        if ($DependentServices){
    
            #Get depending services
            $WinGetSvcDepedning=Invoke-Command -ComputerName $ComputerName -Credential $Global:WinCredential -ScriptBlock{Get-Service -Name $using:WinSvcFinal}
            $WinArraySvcDepnding=$WinGetSvcDepedning.DependentServices | Sort-Object -Unique
   
            Write-Host ("`n" + "At begin it must stop dependent services on computername: " + $ComputerName) -ForegroundColor Green 

            #stop depending services
            $WinGetSvceList=@()
            Foreach ($WinSvceDependTemp in $WinArraySvcDepnding) {
              Invoke-Command -ComputerName $ComputerName -Credential $Global:WinCredential -ScriptBlock{Stop-Service -Name $using:WinSvceDependTemp}
              $WinGetSvceList+=Invoke-Command -ComputerName $ComputerName -Credential $Global:WinCredential -ScriptBlock{Get-Service -Name $using:WinSvceDependTemp}
            } #end foreach ($WinSvceDependTemp in $WinArraySvcDepnding)

            $WinGetSvceList | Format-Table -Property Status, Name, DisplayName -Wrap -AutoSize
            Start-Sleep -Milliseconds 3000
        } #end if ($DependentServices)


        #If WinSvc include stop services
        if (($WinSvcFinal).count -gt 0){
            #Stop mentioned service
            Write-Host ("`n" + "Stop needed services on computername: " + $ComputerName) -ForegroundColor Green
            Invoke-Command -ComputerName $ComputerName -Credential $Global:WinCredential -ScriptBlock{Stop-Service -Name $using:WinSvcFinal}
            Invoke-Command -ComputerName $ComputerName -Credential $Global:WinCredential -ScriptBlock{Get-Service -Name $using:WinSvcFinal} | Format-Table -Property Status, Name, DisplayName -Wrap -AutoSize
        } #end if (($WinSvcFinal).count -eq $null)

        else{
             Write-Host ("There isn't any services can stop on computername: " + $ComputerName) -ForegroundColor Red
        } #end else
        
    } #end if (($WinSrvNumber -eq 1) -and ($Credential -eq $true))

    #Stop service on one computer without credential 
    if (($WinSrvNumber -eq 1) -and ($Credential -eq $false)){

        #Call Function Stop-WinSvceCanStop 
        $Global:WinSvceCredential=0
        Stop-WinSvceCanStop -ComputerName $ComputerName -ServiceName $ServiceName
        $WinSvcFinal=@($Global:ServiceNameCanStop) 

        #At begin stop depending services
        if ($DependentServices){
    
            #Get depending services
            $WinGetSvcDepedning=Invoke-Command -ComputerName $ComputerName -ScriptBlock{Get-Service -Name $using:WinSvcFinal}
            $WinArraySvcDepnding=$WinGetSvcDepedning.DependentServices | Sort-Object -Unique
   
            Write-Host ("`n" + "At begin it must stop dependent services on computername: " + $ComputerName) -ForegroundColor Green 

            #stop depending services
            $WinGetSvceList=@()
            Foreach ($WinSvceDependTemp in $WinArraySvcDepnding) {
              Invoke-Command -ComputerName $ComputerName -ScriptBlock{Stop-Service -Name $using:WinSvceDependTemp}
              $WinGetSvceList+=Invoke-Command -ComputerName $ComputerName -ScriptBlock{Get-Service -Name $using:WinSvceDependTemp}
            } #end foreach ($WinSvceDependTemp in $WinArraySvcDepnding)

            $WinGetSvceList | Format-Table -Property Status, Name, DisplayName -Wrap -AutoSize
            Start-Sleep -Milliseconds 3000
        } #end if ($DependentServices)


        #If WinSvc include stop services
        if (($WinSvcFinal).count -gt 0){
            #Stop mentioned service
            Write-Host ("`n" + "Stop needed services on computername: " + $ComputerName) -ForegroundColor Green
            Invoke-Command -ComputerName $ComputerName -ScriptBlock{Stop-Service -Name $using:WinSvcFinal}
            Invoke-Command -ComputerName $ComputerName -ScriptBlock{Get-Service -Name $using:WinSvcFinal} | Format-Table -Property Status, Name, DisplayName -Wrap -AutoSize
        } #end if (($WinSvcFinal).count -eq $null)

        else{
             Write-Host ("There isn't any services can stop on computername: " + $ComputerName) -ForegroundColor Red
        } #end else
        
    } #end if (($WinSrvNumber -eq 1) -and ($Credential -eq $false))
  
    #Stop service on multi computer with credential
    if (($WinSrvNumber -gt 1) -and ($Credential -eq $true)){

        #Call Get-WinSvceCredential function
         Get-WinSvceCredential
        $Global:WinSvceCredential=1
    
         #Connect to each computer
         for ($counter=0; $counter -lt $WinSrvNumber; $counter++){

            #Call Function Stop-WinSvceCanStop
            Stop-WinSvceCanStop -ComputerName $ComputerName[$counter] -ServiceName $ServiceName -Credential $Global:WinCredential 
            $WinSvcFinal=@($Global:ServiceNameCanStop) 

            #At begin stop depending services
            if ($DependentServices){
                #get depending services
                $WinArraySvcDepnding=$null

                $WinGetSvcDepedingSrv=Invoke-Command -ComputerName $ComputerName[$counter] -Credential $Global:WinCredential -ScriptBlock{Get-Service -Name $using:WinSvcFinal}
                $WinArraySvcDepnding=$WinGetSvcDepedingSrv.DependentServices | Sort-Object -Unique
                Write-Host ("At begin it must stop dependent services on computername: " + $ComputerName[$counter]) -ForegroundColor Green

                #Stop depending services
                $WinGetSvceList=@()
                Foreach ($WinSvceDependTemp in $WinArraySvcDepnding) {
                  Invoke-Command -ComputerName $ComputerName[$counter] -Credential $Global:WinCredential -ScriptBlock{Stop-Service -Name $using:WinSvceDependTemp}
                  $WinGetSvceList+=Invoke-Command -ComputerName $ComputerName[$counter] -Credential $Global:WinCredential -ScriptBlock{Get-Service -Name $using:WinSvceDependTemp}
                } #end foreach ($WinSvceDependTemp in $WinArraySvcDepnding)
          
                  $WinArraySvcDepnding=$null
                  $WinGetSvceList | Format-Table -Property Status, Name, DisplayName -Wrap -AutoSize
                  Start-Sleep -Milliseconds 3000
            } #end if ($DependentServices)
            
            #If WinSvc include services
            if (($WinSvcFinal).count -gt 0){

                #Stop mentioned service
                Write-Host ("Stop needed services on computername: " + $ComputerName[$counter]) -ForegroundColor Green
                Invoke-Command -ComputerName $ComputerName[$counter] -Credential $Global:WinCredential -ScriptBlock{Stop-Service -Name $using:WinSvcFinal}
                Invoke-Command -ComputerName $ComputerName[$counter] -Credential $Global:WinCredential -ScriptBlock{Get-Service -Name $using:WinSvcFinal} | Format-Table -Property Status, Name, DisplayName -Wrap -AutoSize

             } #end if (($WinSvcFinal).count -eq $null)
             
            else{
                Write-Host ("There isn't any services can stop on computername: " + $ComputerName[$counter]) -ForegroundColor Red
            } #end else
        } #end for ($counter=0; $counter -lt $WinSrvNumber; $counter)
    } #end if (($WinSrvNumber -gt 1) -and ($Credential -eq $true))

    #Stop service on multi computer without credential
    if (($WinSrvNumber -gt 1) -and ($Credential -eq $false)){
        
         #Connect to each computer
         for ($counter=0; $counter -lt $WinSrvNumber; $counter++){

            #Call Function Stop-WinSvceCanStop
            $Global:WinSvceCredential=0
            Stop-WinSvceCanStop -ComputerName $ComputerName[$counter] -ServiceName $ServiceName
            $WinSvcFinal=@($Global:ServiceNameCanStop) 

            #At begin stop depending services
            if ($DependentServices){
                #get depending services
                $WinArraySvcDepnding=$null

                $WinGetSvcDepedingSrv=Invoke-Command -ComputerName $ComputerName[$counter] -ScriptBlock{Get-Service -Name $using:WinSvcFinal}
                $WinArraySvcDepnding=$WinGetSvcDepedingSrv.DependentServices | Sort-Object -Unique
                Write-Host ("At begin it must stop dependent services on computername: " + $ComputerName[$counter]) -ForegroundColor Green

                #Stop depending services
                $WinGetSvceList=@()
                Foreach ($WinSvceDependTemp in $WinArraySvcDepnding) {
                  Invoke-Command -ComputerName $ComputerName[$counter] -ScriptBlock{Stop-Service -Name $using:WinSvceDependTemp}
                  $WinGetSvceList+=Invoke-Command -ComputerName $ComputerName[$counter] -ScriptBlock{Get-Service -Name $using:WinSvceDependTemp}
                } #end foreach ($WinSvceDependTemp in $WinArraySvcDepnding)
          
                  $WinArraySvcDepnding=$null
                  $WinGetSvceList | Format-Table -Property Status, Name, DisplayName -Wrap -AutoSize
                  Start-Sleep -Milliseconds 3000
            } #end if ($DependentServices)
            
            #If WinSvc include services
            if (($WinSvcFinal).count -gt 0){

                #Stop mentioned service
                Write-Host ("Stop needed services on computername: " + $ComputerName[$counter]) -ForegroundColor Green
                Invoke-Command -ComputerName $ComputerName[$counter] -ScriptBlock{Stop-Service -Name $using:WinSvcFinal}
                Invoke-Command -ComputerName $ComputerName[$counter] -ScriptBlock{Get-Service -Name $using:WinSvcFinal} | Format-Table -Property Status, Name, DisplayName -Wrap -AutoSize

             } #end if (($WinSvcFinal).count -eq $null)
             
            else{
                Write-Host ("There isn't any services can stop on computername: " + $ComputerName[$counter]) -ForegroundColor Red
            } #end else
        } #end for ($counter=0; $counter -lt $WinSrvNumber; $counter)
    } #end if (($WinSrvNumber -gt 1) -and ($Credential -eq $false))

   #Remove trusted hosts
   Clear-Item WSMan:\localhost\Client\TrustedHosts -Force
         
} #end Function Stop-WinSvce


###############Stop-WinSvceCanStop Function################
Function Stop-WinSvceCanStop {

    <#
	.SYNOPSIS
		This function used by another function to include stoppable services into global array.
    #>
    
    param ($ComputerName,
          $ServiceName,
          [Switch]$Credential)
    
    #Set trusted hosts
    Set-Item WSMan:\localhost\Client\TrustedHosts –Value “*” -ea 0 -Force

    #Force array to accept one value or more
    [System.Collections.ArrayList]$WinSvceArray=@($ServiceName)

    #Verfiy invoke command with credential or not
    if ($Global:WinSvceCredential -eq 1){
        $WinGetSvce=Invoke-Command -ComputerName $ComputerName -Credential $Global:WinCredential -ScriptBlock{Get-Service -Name $using:WinSvceArray}
    } #end if ($Global:WinSvceCredential -eq 1)

    elseif ($Global:WinSvceCredential -eq 0){
            $WinGetSvce=Invoke-Command -ComputerName $ComputerName -ScriptBlock{Get-Service -Name $using:WinSvceArray}
    } #end elseif ($Global:WinSvceCredential -eq 0)

    $WinSvceNumber=($ServiceName).Count

    #Remove unable service to stop
    for ($counter=0; $counter -lt $WinSvceNumber; $counter++){
        if ($WinGetSvce[$counter].CanStop -eq $false){
            Write-Host ("The service name ") -ForegroundColor Yellow -NoNewline
            Write-Host (($WinGetSvce[$counter]).DisplayName) -ForegroundColor Green -NoNewline
            Write-Host (" is unble to stop or already stopped before on computername: ") -ForegroundColor Yellow -NoNewline
            Write-Host ($ComputerName) -ForegroundColor Green
            $WinSvceArray.Remove(($WinGetSvce[$counter]).Name)
        } #end if ($WinGetSvce[$counter].CanStop -eq $false)
     } #end for ($counter=0; $counter -lt $WinSvceNumber; $counter++)

    #Service name output
    $Global:ServiceNameCanStop=$WinSvceArray
} #end Function Stop-WinSvceCanStop

###############Resume-WinSvce Function################
Function Resume-WinSvce {

        <#
	.SYNOPSIS
		This function help you to resume needed service, no matter how many computers, services or apply it on local machine or even remotely.
	
	.DESCRIPTION
		Use this function to control resume services, no need to consider if a service resumable or not because it has ability to find out resumable services from many provided services through command typed. 

	.PARAMETER ComputerName
		Indicates the property to provide one computername or many .
	
	.PARAMETER ServiceName
		Indicates the property to provide one service name or many .
	
	.PARAMETER Credential
		Indicates the property to call another function under name Get-WinSvceCredential and be able connect on computer with different credentials.
	
	.EXAMPLE
	    Resume-WinSvce -ComputerName Server1 -ServiceName W32Time

	.EXAMPLE
		Resume-WinSvce	-ComputerName Server1 -ServiceName W32Time,iphlpsvc
	
	.EXAMPLE
		Resume-WinSvce -ComputerName Server1,Server2 -ServiceName W32Time,iphlpsvc -Credential
   #>


    param ($ComputerName,
           $ServiceName,
           [Switch]$Credential)

    #Set trusted hosts
    Set-Item WSMan:\localhost\Client\TrustedHosts –Value “*” -ea 0 -Force

    #Get number of computers
    $WinSrvNumber=($ComputerName).count

    #Resume service on one computer with credential
    if (($WinSrvNumber -eq 1) -and ($Credential -eq $true)){

            #Call Get-WinSvceCredential function
            Get-WinSvceCredential
        
            #Create variable accept single or multi values
            [System.Collections.ArrayList]$WinSvceName=@($ServiceName)    

            #Verify ability to resume service
            $WinGetSvce=Invoke-Command -ComputerName $ComputerName -Credential $Global:WinCredential -ScriptBlock{Get-Service -Name $using:WinSvceName}
            $WinGetSvceResume=$WinGetSvce.CanPauseAndContinue
                     
            #Exclude inapplicable resume service
            if ($WinGetSvceResume -contains $false){
                
                #Get inapplicable resume services
                $WinGetSvceCantResume=$WinGetSvce | Where-Object CanPauseAndContinue -match 'false'

                #Remove inapplicable resume services                    
                foreach ($WinGetSvceCantResumeTemp in $WinGetSvceCantResume){
                     Write-Host ("It's unble to resume services name ") -NoNewline -ForegroundColor Green
                     Write-Host (($WinGetSvceCantResumeTemp).DisplayName) -NoNewline -ForegroundColor Yellow
                     Write-Host (" on computername: " + $ComputerName) -ForegroundColor Green

                     $WinSvceName.Remove(($WinGetSvceCantResumeTemp).Name)
                } #end foreach ($WinGetSvceCantResumeTemp in $WinGetSvceCantResume)
            } #end if ($WinGetSvceResume -contains $false)
               

            if (($WinSvceName).Count -eq 0){
                 Write-Host ("There isn't any services able to resume on computername: " + $ComputerName) -ForegroundColor Red
             } #end if (($WinSvceName).Count -eq 0)

            else{
                #Resume mentioned service
                Write-Host ("`n" + "Resume needed services on computername: " + $ComputerName) -ForegroundColor Green
                Invoke-Command -ComputerName $ComputerName -Credential $Global:WinCredential -ScriptBlock{Resume-Service -Name $using:WinSvceName}
                Invoke-Command -ComputerName $ComputerName -Credential $Global:WinCredential -ScriptBlock{Get-Service -Name $using:WinSvceName} | Format-Table -Property Status, Name, DisplayName -Wrap -AutoSize
             } #end else

  
    } #end if (($WinSrvNumber -eq 1) -and ($Credential -eq $true))


    #Resume service on one computer without credential
    if (($WinSrvNumber -eq 1) -and ($Credential -eq $false)){

        
            #Create variable accept single or multi values
            [System.Collections.ArrayList]$WinSvceName=@($ServiceName)    

            #Verify ability to resume service
            $WinGetSvce=Invoke-Command -ComputerName $ComputerName -ScriptBlock{Get-Service -Name $using:WinSvceName}
            $WinGetSvceResume=$WinGetSvce.CanPauseAndContinue
                     
            #Exclude inapplicable resume service
            if ($WinGetSvceResume -contains $false){
                
                #Get inapplicable resume services
                $WinGetSvceCantResume=$WinGetSvce | Where-Object CanPauseAndContinue -match 'false'

                #Remove inapplicable resume services                    
                foreach ($WinGetSvceCantResumeTemp in $WinGetSvceCantResume){
                     Write-Host ("It's unble to resume services name ") -NoNewline -ForegroundColor Green
                     Write-Host (($WinGetSvceCantResumeTemp).DisplayName) -NoNewline -ForegroundColor Yellow
                     Write-Host (" on computername: " + $ComputerName) -ForegroundColor Green

                     $WinSvceName.Remove(($WinGetSvceCantResumeTemp).Name)
                } #end foreach ($WinGetSvceCantResumeTemp in $WinGetSvceCantResume)
            } #end if ($WinGetSvceResume -contains $false)
               

            if (($WinSvceName).Count -eq 0){
                 Write-Host ("There isn't any services able to resume on computername: " + $ComputerName) -ForegroundColor Red
             } #end if (($WinSvceName).Count -eq 0)

            else{
                #Resume mentioned service
                Write-Host ("`n" + "Resume needed services on computername: " + $ComputerName) -ForegroundColor Green
                Invoke-Command -ComputerName $ComputerName -ScriptBlock{Resume-Service -Name $using:WinSvceName}
                Invoke-Command -ComputerName $ComputerName -ScriptBlock{Get-Service -Name $using:WinSvceName} | Format-Table -Property Status, Name, DisplayName -Wrap -AutoSize
             } #end else

  
    } #end if (($WinSrvNumber -eq 1) -and ($Credential -eq $false))


    #Resume service on multi computer with credential
    if (($WinSrvNumber -gt 1) -and ($Credential -eq $true)){
            
            #Call Get-Global:WinCredential function
            Get-WinSvceCredential

            #Connect to each computer
            for ($counter=0; $counter -lt $WinSrvNumber; $counter++){
            
                #Create variable accept single or multi values
                [System.Collections.ArrayList]$WinSvceName=@($ServiceName)

                #Verify ability to resume service
                $WinGetSvce=Invoke-Command -ComputerName $ComputerName[$counter] -Credential $Global:WinCredential -ScriptBlock{Get-Service -Name $using:WinSvceName}
                $WinGetSvceResume=$WinGetSvce.CanPauseAndContinue
                     
                #Exclude inapplicable resume service
                if ($WinGetSvceResume -contains $false){
                
                    #Get inapplicable resume services
                    $WinGetSvceCantResume=$WinGetSvce | Where-Object CanPauseAndContinue -match 'false'

                    #Remove inapplicable resume services                    
                    foreach ($WinGetSvceCantResumeTemp in $WinGetSvceCantResume){
                         Write-Host ("It's unble to resume services name ") -NoNewline -ForegroundColor Green
                         Write-Host (($WinGetSvceCantResumeTemp).DisplayName) -NoNewline -ForegroundColor Yellow
                         Write-Host (" on computername: " + $ComputerName[$counter]) -ForegroundColor Green

                         $WinSvceName.Remove(($WinGetSvceCantResumeTemp).Name)
                    } #end foreach ($WinGetSvceCantResumeTemp in $WinGetSvceCantResume)
               
                 } #end if ($WinGetSvceResume -contains $false)

                if (($WinSvceName).Count -eq 0){
                     Write-Host ("There isn't any services able to resume on computername: " + $ComputerName[$counter]) -ForegroundColor Red
                 } #end if (($WinSvceName).Count -eq 0)

                else{
                    #Resume mentioned service
                    Write-Host ("`n" + "Resume needed services on computername: " + $ComputerName[$counter]) -ForegroundColor Green
                    Invoke-Command -ComputerName $ComputerName[$counter] -Credential $Global:WinCredential -ScriptBlock{Resume-Service -Name $using:WinSvceName}
                    Invoke-Command -ComputerName $ComputerName[$counter] -Credential $Global:WinCredential -ScriptBlock{Get-Service -Name $using:WinSvceName} | Format-Table -Property Status, Name, DisplayName -Wrap -AutoSize
                 } #end else

        } # end for ($counter=0; $counter -lt $WinSrvNumber; $counter++)
    } #end if (($WinSrvNumber -gt 1) -and ($Credential -eq $true))


    #Resume service on multi computer without credential
    if (($WinSrvNumber -gt 1) -and ($Credential -eq $false)){
            

            #Connect to each computer
            for ($counter=0; $counter -lt $WinSrvNumber; $counter++){
            
                #Create variable accept single or multi values
                [System.Collections.ArrayList]$WinSvceName=@($ServiceName)

                #Verify ability to resume service
                $WinGetSvce=Invoke-Command -ComputerName $ComputerName[$counter] -ScriptBlock{Get-Service -Name $using:WinSvceName}
                $WinGetSvceResume=$WinGetSvce.CanPauseAndContinue
                     
                #Exclude inapplicable resume service
                if ($WinGetSvceResume -contains $false){
                
                    #Get inapplicable resume services
                    $WinGetSvceCantResume=$WinGetSvce | Where-Object CanPauseAndContinue -match 'false'

                    #Remove inapplicable resume services                    
                    foreach ($WinGetSvceCantResumeTemp in $WinGetSvceCantResume){
                         Write-Host ("It's unble to resume services name ") -NoNewline -ForegroundColor Green
                         Write-Host (($WinGetSvceCantResumeTemp).DisplayName) -NoNewline -ForegroundColor Yellow
                         Write-Host (" on computername: " + $ComputerName[$counter]) -ForegroundColor Green

                         $WinSvceName.Remove(($WinGetSvceCantResumeTemp).Name)
                    } #end foreach ($WinGetSvceCantResumeTemp in $WinGetSvceCantResume)
               
                 } #end if ($WinGetSvceResume -contains $false)

                if (($WinSvceName).Count -eq 0){
                     Write-Host ("There isn't any services able to resume on computername: " + $ComputerName[$counter]) -ForegroundColor Red
                 } #end if (($WinSvceName).Count -eq 0)

                else{
                    #Resume mentioned service
                    Write-Host ("`n" + "Resume needed services on computername: " + $ComputerName[$counter]) -ForegroundColor Green
                    Invoke-Command -ComputerName $ComputerName[$counter] -ScriptBlock{Resume-Service -Name $using:WinSvceName}
                    Invoke-Command -ComputerName $ComputerName[$counter] -ScriptBlock{Get-Service -Name $using:WinSvceName} | Format-Table -Property Status, Name, DisplayName -Wrap -AutoSize
                 } #end else

        } # end for ($counter=0; $counter -lt $WinSrvNumber; $counter++)
    } #end if (($WinSrvNumber -gt 1) -and ($Credential -eq $false))

    #Remove trusted hosts
    Clear-Item WSMan:\localhost\Client\TrustedHosts -Force
         
} #end Function Resume-WinSvce


###############Pause-WinSvce Function###############
Function Pause-WinSvce {

   <#
	.SYNOPSIS
		This function help you to suspend needed service, no matter how many computers, services or apply it on local machine or even remotely.
	
	.DESCRIPTION
		Use this function to control suspend services, no need to consider if a service able to pause or not because it has ability to find out this automatically from many provided services through command typed. 

	.PARAMETER ComputerName
		Indicates the property to provide one computername or many .
	
	.PARAMETER ServiceName
		Indicates the property to provide one service name or many .
	
	.PARAMETER Credential
		Indicates the property to call another function under name Get-WinSvceCredential and be able connect on computer with different credentials.
	
	.EXAMPLE
	    Pause-WinSvce -ComputerName Server1 -ServiceName W32Time

	.EXAMPLE
		Pause-WinSvce	-ComputerName Server1 -ServiceName W32Time,iphlpsvc
	
	.EXAMPLE
		Pause-WinSvce -ComputerName Server1,Server2 -ServiceName W32Time,iphlpsvc -Credential
   #>


    param ($ComputerName,
           $ServiceName,
           [Switch]$Credential)

    #Set trusted hosts
    Set-Item WSMan:\localhost\Client\TrustedHosts –Value “*” -ea 0 -Force

    #Get number of computers
    $WinSrvNumber=($ComputerName).count

    #Pause service on one computer with credential
    if (($WinSrvNumber -eq 1) -and ($Credential -eq $true)){

            #Call Get-WinSvceCredential function
            Get-WinSvceCredential
        
            #Create variable accept single or multi values
            [System.Collections.ArrayList]$WinSvceName=@($ServiceName)    

            #Verify ability to pause service
            $WinGetSvce=Invoke-Command -ComputerName $ComputerName -Credential $Global:WinCredential -ScriptBlock{Get-Service -Name $using:WinSvceName}
            $WinGetSvcePause=$WinGetSvce.CanPauseAndContinue
                     
            #Exclude inapplicable pause service
            if ($WinGetSvcePause -contains $false){
                
                #Get inapplicable pause services
                $WinGetSvceCantPause=$WinGetSvce | Where-Object CanPauseAndContinue -match 'false'

                #Remove inapplicable pause services                    
                foreach ($WinGetSvceCantPauseTemp in $WinGetSvceCantPause){
                     Write-Host ("It's unble to pause services name ") -NoNewline -ForegroundColor Green
                     Write-Host (($WinGetSvceCantPauseTemp).DisplayName) -NoNewline -ForegroundColor Yellow
                     Write-Host (" on computername: " + $ComputerName) -ForegroundColor Green

                     $WinSvceName.Remove(($WinGetSvceCantPauseTemp).Name)
                } #end foreach ($WinGetSvceCantPauseTemp in $WinGetSvceCantPause)
            } #end if ($WinGetSvcePause -contains $false)
               

            if (($WinSvceName).Count -eq 0){
                 Write-Host ("There isn't any services able to pause on computername: " + $ComputerName) -ForegroundColor Red
             } #end if (($WinSvceName).Count -eq 0)

            else{
                #Pause mentioned service
                Write-Host ("`n" + "Pause needed services on computername: " + $ComputerName) -ForegroundColor Green
                Invoke-Command -ComputerName $ComputerName -Credential $Global:WinCredential -ScriptBlock{Suspend-Service -Name $using:WinSvceName}
                Invoke-Command -ComputerName $ComputerName -Credential $Global:WinCredential -ScriptBlock{Get-Service -Name $using:WinSvceName} | Format-Table -Property Status, Name, DisplayName -Wrap -AutoSize
             } #end else

  
    } #end if (($WinSrvNumber -eq 1) -and ($Credential -eq $true))

    #Pause service on one computer without credential
    if (($WinSrvNumber -eq 1) -and ($Credential -eq $false)){
        
            #Create variable accept single or multi values
            [System.Collections.ArrayList]$WinSvceName=@($ServiceName)    

            #Verify ability to pause service
            $WinGetSvce=Invoke-Command -ComputerName $ComputerName -ScriptBlock{Get-Service -Name $using:WinSvceName}
            $WinGetSvcePause=$WinGetSvce.CanPauseAndContinue
                     
            #Exclude inapplicable pause service
            if ($WinGetSvcePause -contains $false){
                
                #Get inapplicable pause services
                $WinGetSvceCantPause=$WinGetSvce | Where-Object CanPauseAndContinue -match 'false'

                #Remove inapplicable pause services                    
                foreach ($WinGetSvceCantPauseTemp in $WinGetSvceCantPause){
                     Write-Host ("It's unble to pause services name ") -NoNewline -ForegroundColor Green
                     Write-Host (($WinGetSvceCantPauseTemp).DisplayName) -NoNewline -ForegroundColor Yellow
                     Write-Host (" on computername: " + $ComputerName) -ForegroundColor Green

                     $WinSvceName.Remove(($WinGetSvceCantPauseTemp).Name)
                } #end foreach ($WinGetSvceCantPauseTemp in $WinGetSvceCantPause)
            } #end if ($WinGetSvcePause -contains $false)
               

            if (($WinSvceName).Count -eq 0){
                 Write-Host ("There isn't any services able to pause on computername: " + $ComputerName) -ForegroundColor Red
             } #end if (($WinSvceName).Count -eq 0)

            else{
                #Pause mentioned service
                Write-Host ("`n" + "Pause needed services on computername: " + $ComputerName) -ForegroundColor Green
                Invoke-Command -ComputerName $ComputerName -ScriptBlock{Suspend-Service -Name $using:WinSvceName}
                Invoke-Command -ComputerName $ComputerName -ScriptBlock{Get-Service -Name $using:WinSvceName} | Format-Table -Property Status, Name, DisplayName -Wrap -AutoSize
             } #end else

  
    } #end if (($WinSrvNumber -eq 1) -and ($Credential -eq $false))

    #Pause service on multi computer with credential
    if (($WinSrvNumber -gt 1) -and ($Credential -eq $true)){
            
            #Call Get-Global:WinCredential function
            Get-WinSvceCredential

            #Connect to each computer
            for ($counter=0; $counter -lt $WinSrvNumber; $counter++){
            
            #Create variable accept single or multi values
            [System.Collections.ArrayList]$WinSvceName=@($ServiceName)

            #Verify ability to pause service
            $WinGetSvce=Invoke-Command -ComputerName $ComputerName[$counter] -Credential $Global:WinCredential -ScriptBlock{Get-Service -Name $using:WinSvceName}
            $WinGetSvcePause=$WinGetSvce.CanPauseAndContinue
                     
            #Exclude inapplicable pause service
            if ($WinGetSvcePause -contains $false){
                
                #Get inapplicable pause services
                $WinGetSvceCantPause=$WinGetSvce | Where-Object CanPauseAndContinue -match 'false'

                #Remove inapplicable pause services                    
                foreach ($WinGetSvceCantPauseTemp in $WinGetSvceCantPause){
                     Write-Host ("It's unble to pause services name ") -NoNewline -ForegroundColor Green
                     Write-Host (($WinGetSvceCantPauseTemp).DisplayName) -NoNewline -ForegroundColor Yellow
                     Write-Host (" on computername: " + $ComputerName[$counter]) -ForegroundColor Green

                     $WinSvceName.Remove(($WinGetSvceCantPauseTemp).Name)
                } #end foreach ($WinGetSvceCantPauseTemp in $WinGetSvceCantPause)
               
             } #end if ($WinGetSvcePause -contains $false)

            if (($WinSvceName).Count -eq 0){
                 Write-Host ("There isn't any services able to pause on computername: " + $ComputerName[$counter]) -ForegroundColor Red
             } #end if (($WinSvceName).Count -eq 0)

            else{
                #Pause mentioned service
                Write-Host ("`n" + "Pause needed services on computername: " + $ComputerName[$counter]) -ForegroundColor Green
                Invoke-Command -ComputerName $ComputerName[$counter] -Credential $Global:WinCredential -ScriptBlock{Suspend-Service -Name $using:WinSvceName}
                Invoke-Command -ComputerName $ComputerName[$counter] -Credential $Global:WinCredential -ScriptBlock{Get-Service -Name $using:WinSvceName} | Format-Table -Property Status, Name, DisplayName -Wrap -AutoSize
             } #end else

        } # end for ($counter=0; $counter -lt $WinSrvNumber; $counter++)
    } #end if (($WinSrvNumber -gt 1) -and ($Credential -eq $true))

    #Pause service on multi computer without credential
    if (($WinSrvNumber -gt 1) -and ($Credential -eq $false)){
            
       #Connect to each computer
       for ($counter=0; $counter -lt $WinSrvNumber; $counter++){
            
            #Create variable accept single or multi values
            [System.Collections.ArrayList]$WinSvceName=@($ServiceName)

            #Verify ability to pause service
            $WinGetSvce=Invoke-Command -ComputerName $ComputerName[$counter] -ScriptBlock{Get-Service -Name $using:WinSvceName}
            $WinGetSvcePause=$WinGetSvce.CanPauseAndContinue
                     
            #Exclude inapplicable pause service
            if ($WinGetSvcePause -contains $false){
                
                #Get inapplicable pause services
                $WinGetSvceCantPause=$WinGetSvce | Where-Object CanPauseAndContinue -match 'false'

                #Remove inapplicable pause services                    
                foreach ($WinGetSvceCantPauseTemp in $WinGetSvceCantPause){
                     Write-Host ("It's unble to pause services name ") -NoNewline -ForegroundColor Green
                     Write-Host (($WinGetSvceCantPauseTemp).DisplayName) -NoNewline -ForegroundColor Yellow
                     Write-Host (" on computername: " + $ComputerName[$counter]) -ForegroundColor Green

                     $WinSvceName.Remove(($WinGetSvceCantPauseTemp).Name)
                } #end foreach ($WinGetSvceCantPauseTemp in $WinGetSvceCantPause)
               
             } #end if ($WinGetSvcePause -contains $false)

            if (($WinSvceName).Count -eq 0){
                 Write-Host ("There isn't any services able to pause on computername: " + $ComputerName[$counter]) -ForegroundColor Red
             } #end if (($WinSvceName).Count -eq 0)

            else{
                #Pause mentioned service
                Write-Host ("`n" + "Pause needed services on computername: " + $ComputerName[$counter]) -ForegroundColor Green
                Invoke-Command -ComputerName $ComputerName[$counter] -ScriptBlock{Suspend-Service -Name $using:WinSvceName}
                Invoke-Command -ComputerName $ComputerName[$counter] -ScriptBlock{Get-Service -Name $using:WinSvceName} | Format-Table -Property Status, Name, DisplayName -Wrap -AutoSize
             } #end else

        } # end for ($counter=0; $counter -lt $WinSrvNumber; $counter++)
    } #end if (($WinSrvNumber -gt 1) -and ($Credential -eq $false))

   #Remove trusted hosts
   Clear-Item WSMan:\localhost\Client\TrustedHosts -Force
            
} #end Function Pause-WinSvce


###############Restart-WinSvce Function###############
Function Restart-WinSvce {

    <#
	.SYNOPSIS
		This function help you to restart needed service, no matter how many computers, services or apply it on local machine or even remotely.
	
	.DESCRIPTION
		Use this function to control restart services after provide concern services.

	.PARAMETER ComputerName
		Indicates the property to provide one computername or many .
	
	.PARAMETER ServiceName
		Indicates the property to provide one service name or many .
	
	.PARAMETER Credential
		Indicates the property to call another function under name Get-WinSvceCredential and be able connect on computer with different credentials.
	
	.EXAMPLE
	    Restart-WinSvce -ComputerName Server1 -ServiceName W32Time

	.EXAMPLE
		Restart-WinSvce	-ComputerName Server1 -ServiceName W32Time,iphlpsvc
	
	.EXAMPLE
		Restart-WinSvce -ComputerName Server1,Server2 -ServiceName W32Time,iphlpsvc -Credential
   #>


    param ($ComputerName,
           $ServiceName,
           [Switch]$Credential)

    #Set trusted hosts
    Set-Item WSMan:\localhost\Client\TrustedHosts –Value “*” -ea 0 -Force

    #Get number of computers
    $WinSrvNumber=($ComputerName).count

    #Restart service on one computer with credential
    if (($WinSrvNumber -eq 1) -and ($Credential -eq $true)){

            #Call Get-WinSvceCredential function
            Get-WinSvceCredential
        
            #Create variable accept single or multi values
            [System.Collections.ArrayList]$WinSvceName=@($ServiceName)    

            #Verify ability to restart service
            $WinGetSvce=Invoke-Command -ComputerName $ComputerName -Credential $Global:WinCredential -ScriptBlock{Get-Service -Name $using:WinSvceName}
            $WinGetSvceRestart=$WinGetSvce.CanStop
                     
            #Exclude inapplicable restart service
            if ($WinGetSvceRestart -contains $false){
                
                #Get inapplicable restart services
                $WinGetSvceCantRestart=$WinGetSvce | Where-Object CanStop -match 'false'

                #Remove inapplicable restart services                    
                foreach ($WinGetSvceCantRestartTemp in $WinGetSvceCantRestart){
                     Write-Host ("It's unble to restart services name ") -NoNewline -ForegroundColor Green
                     Write-Host (($WinGetSvceCantRestartTemp).DisplayName) -NoNewline -ForegroundColor Yellow
                     Write-Host (" on computername: " + $ComputerName) -ForegroundColor Green

                     $WinSvceName.Remove(($WinGetSvceCantRestartTemp).Name)
                } #end foreach ($WinGetSvceCantRestartTemp in $WinGetSvceCantRestart)
            } #end if ($WinGetSvceRestart -contains $false)
               

            if (($WinSvceName).Count -eq 0){
                 Write-Host ("There isn't any services able to restart on computername: " + $ComputerName) -ForegroundColor Red
             } #end if (($WinSvceName).Count -eq 0)

            else{
                #Restart mentioned service
                Write-Host ("`n" + "Restart needed services on computername: " + $ComputerName) -ForegroundColor Green
                Invoke-Command -ComputerName $ComputerName -Credential $Global:WinCredential -ScriptBlock{Restart-Service -Name $using:WinSvceName}
                Invoke-Command -ComputerName $ComputerName -Credential $Global:WinCredential -ScriptBlock{Get-Service -Name $using:WinSvceName} | Format-Table -Property Status, Name, DisplayName -Wrap -AutoSize
             } #end else

  
    } #end if (($WinSrvNumber -eq 1) -and ($Credential -eq $true))


    #Restart service on one computer without credential
    if (($WinSrvNumber -eq 1) -and ($Credential -eq $false)){

        
            #Create variable accept single or multi values
            [System.Collections.ArrayList]$WinSvceName=@($ServiceName)    

            #Verify ability to restart service
            $WinGetSvce=Invoke-Command -ComputerName $ComputerName -ScriptBlock{Get-Service -Name $using:WinSvceName}
            $WinGetSvceRestart=$WinGetSvce.CanStop
                     
            #Exclude inapplicable restart service
            if ($WinGetSvceRestart -contains $false){
                
                #Get inapplicable restart services
                $WinGetSvceCantRestart=$WinGetSvce | Where-Object CanStop -match 'false'

                #Remove inapplicable restart services                    
                foreach ($WinGetSvceCantRestartTemp in $WinGetSvceCantRestart){
                     Write-Host ("It's unble to restart services name ") -NoNewline -ForegroundColor Green
                     Write-Host (($WinGetSvceCantRestartTemp).DisplayName) -NoNewline -ForegroundColor Yellow
                     Write-Host (" on computername: " + $ComputerName) -ForegroundColor Green

                     $WinSvceName.Remove(($WinGetSvceCantRestartTemp).Name)
                } #end foreach ($WinGetSvceCantRestartTemp in $WinGetSvceCantRestart)
            } #end if ($WinGetSvceRestart -contains $false)
               

            if (($WinSvceName).Count -eq 0){
                 Write-Host ("There isn't any services able to restart on computername: " + $ComputerName) -ForegroundColor Red
             } #end if (($WinSvceName).Count -eq 0)

            else{
                #Restart mentioned service
                Write-Host ("`n" + "Restart needed services on computername: " + $ComputerName) -ForegroundColor Green
                Invoke-Command -ComputerName $ComputerName -ScriptBlock{Restart-Service -Name $using:WinSvceName}
                Invoke-Command -ComputerName $ComputerName -ScriptBlock{Get-Service -Name $using:WinSvceName} | Format-Table -Property Status, Name, DisplayName -Wrap -AutoSize
             } #end else

  
    } #end if (($WinSrvNumber -eq 1) -and ($Credential -eq $false))


    #Restart service on multi computer with credential
    if (($WinSrvNumber -gt 1) -and ($Credential -eq $true)){
            
            #Call Get-WinSvceCredential function
            Get-WinSvceCredential

            #Connect to each computer
            for ($counter=0; $counter -lt $WinSrvNumber; $counter++){
            
                #Create variable accept single or multi values
                [System.Collections.ArrayList]$WinSvceName=@($ServiceName)

                #Verify ability to restart service
                $WinGetSvce=Invoke-Command -ComputerName $ComputerName[$counter] -Credential $Global:WinCredential -ScriptBlock{Get-Service -Name $using:WinSvceName}
                $WinGetSvceRestart=$WinGetSvce.CanStop
                     
                #Exclude inapplicable restart service
                if ($WinGetSvceRestart -contains $false){
                
                    #Get inapplicable restart services
                    $WinGetSvceCantRestart=$WinGetSvce | Where-Object CanStop -match 'false'

                    #Remove inapplicable restart services                    
                    foreach ($WinGetSvceCantRestartTemp in $WinGetSvceCantRestart){
                         Write-Host ("It's unble to restart services name ") -NoNewline -ForegroundColor Green
                         Write-Host (($WinGetSvceCantRestartTemp).DisplayName) -NoNewline -ForegroundColor Yellow
                         Write-Host (" on computername: " + $ComputerName[$counter]) -ForegroundColor Green

                         $WinSvceName.Remove(($WinGetSvceCantRestartTemp).Name)
                    } #end foreach ($WinGetSvceCantRestartTemp in $WinGetSvceCantRestart)
               
                 } #end if ($WinGetSvceRestart -contains $false)

                if (($WinSvceName).Count -eq 0){
                     Write-Host ("There isn't any services able to restart on computername: " + $ComputerName[$counter]) -ForegroundColor Red
                 } #end if (($WinSvceName).Count -eq 0)

                else{
                    #Restart mentioned service
                    Write-Host ("`n" + "Restart needed services on computername: " + $ComputerName[$counter]) -ForegroundColor Green
                    Invoke-Command -ComputerName $ComputerName[$counter] -Credential $Global:WinCredential -ScriptBlock{Restart-Service -Name $using:WinSvceName}
                    Invoke-Command -ComputerName $ComputerName[$counter] -Credential $Global:WinCredential -ScriptBlock{Get-Service -Name $using:WinSvceName} | Format-Table -Property Status, Name, DisplayName -Wrap -AutoSize
                 } #end else

        } # end for ($counter=0; $counter -lt $WinSrvNumber; $counter++)
    } #end if (($WinSrvNumber -gt 1) -and ($Credential -eq $true))


    #Restart service on multi computer without credential
    if (($WinSrvNumber -gt 1) -and ($Credential -eq $false)){
            

            #Connect to each computer
            for ($counter=0; $counter -lt $WinSrvNumber; $counter++){
            
                #Create variable accept single or multi values
                [System.Collections.ArrayList]$WinSvceName=@($ServiceName)

                #Verify ability to restart service
                $WinGetSvce=Invoke-Command -ComputerName $ComputerName[$counter] -ScriptBlock{Get-Service -Name $using:WinSvceName}
                $WinGetSvceRestart=$WinGetSvce.CanStop
                     
                #Exclude inapplicable restart service
                if ($WinGetSvceRestart -contains $false){
                
                    #Get inapplicable restart services
                    $WinGetSvceCantRestart=$WinGetSvce | Where-Object CanStop -match 'false'

                    #Remove inapplicable restart services                    
                    foreach ($WinGetSvceCantRestartTemp in $WinGetSvceCantRestart){
                         Write-Host ("It's unble to restart services name ") -NoNewline -ForegroundColor Green
                         Write-Host (($WinGetSvceCantRestartTemp).DisplayName) -NoNewline -ForegroundColor Yellow
                         Write-Host (" on computername: " + $ComputerName[$counter]) -ForegroundColor Green

                         $WinSvceName.Remove(($WinGetSvceCantRestartTemp).Name)
                    } #end foreach ($WinGetSvceCantRestartTemp in $WinGetSvceCantRestart)
               
                 } #end if ($WinGetSvceRestart -contains $false)

                if (($WinSvceName).Count -eq 0){
                     Write-Host ("There isn't any services able to restart on computername: " + $ComputerName[$counter]) -ForegroundColor Red
                 } #end if (($WinSvceName).Count -eq 0)

                else{
                    #Restart mentioned service
                    Write-Host ("`n" + "Restart needed services on computername: " + $ComputerName[$counter]) -ForegroundColor Green
                    Invoke-Command -ComputerName $ComputerName[$counter] -ScriptBlock{Restart-Service -Name $using:WinSvceName}
                    Invoke-Command -ComputerName $ComputerName[$counter] -ScriptBlock{Get-Service -Name $using:WinSvceName} | Format-Table -Property Status, Name, DisplayName -Wrap -AutoSize
                 } #end else

        } # end for ($counter=0; $counter -lt $WinSrvNumber; $counter++)
    } #end if (($WinSrvNumber -gt 1) -and ($Credential -eq $false))

    #Remove trusted hosts
    Clear-Item WSMan:\localhost\Client\TrustedHosts -Force
         
} #end Function Restart-WinSvce


