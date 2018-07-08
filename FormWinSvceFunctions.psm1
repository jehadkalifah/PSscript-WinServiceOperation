###########Get-FormWinSvce Function#####################
Function Get-FormWinSvce {
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
                                
        #WinCheckCred variable send value to Get-FormWinSvceDisplayOptions function to determine use credential or not
        $WinCheckCred=1

        #Call Get-Global:WinCredential function
        if ($Global:WinCredential -eq $null){
              Get-FormWinSvceCredential
        } #end  if ($Global:WinCredential -eq $null)
        
        #Get services based on function Get-FormWinSvceDisplayOptions
        if ($DisplayOptoins){
            
            #Call Function Get-FormWinSvceDisplayOptions
            $WinSvceProperty = Get-FormWinSvceDisplayOptions

            
            #Get services
            Write-Output ("* Display services on computername: " + $ComputerName)

            #Foreach to include server type into service details if checked
            $WinGetSvc=@()
            foreach ($WinSvceTypeTemp in $ServiceName){
                 $WinGetSvc+=Invoke-Command -ComputerName $ComputerName -Credential $Global:WinCredential -ScriptBlock{Get-Service -Name $using:WinSvceTypeTemp} | Select-Object $WinSvceProperty
            } #end  foreach ($WinSvceTypeTemp in $ServiceName)

            #Display get services after choose concern display properties
            $WinGetSvc |  Format-Table -Wrap -AutoSize
        } #end if ($DisplayOptoins)

        else{
        #get  service wtih default display options
        Write-Output ("* Display services on computername: " + $ComputerName)
        Invoke-Command -ComputerName $ComputerName -Credential $Global:WinCredential -ScriptBlock{Get-Service -Name $using:ServiceName} | Format-Table -Property Status, Name, DisplayName -Wrap -AutoSize
        } #end else
    } #end if (($WinSrvNumber -eq 1) -and ($Credential -eq $true))

            
   #Get service on one computer without credential
   if (($WinSrvNumber -eq 1) -and ($Credential -eq $false)){

        #WinCheckCred variable send value to Get-FormWinSvceDisplayOptions function to determine use credential or not
        $WinCheckCred=0
        
        #Get services based on function Get-FormWinSvceDisplayOptions
        if ($DisplayOptoins){
            
            #Call Function Get-FormWinSvceDisplayOptions
            $WinSvceProperty = Get-FormWinSvceDisplayOptions

            
            #Get services
            Write-Output ("* Display services on computername: " + $ComputerName)

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
        Write-Output ("* Display services on computername: " + $ComputerName)
        Invoke-Command -ComputerName $ComputerName -ScriptBlock{Get-Service -Name $using:ServiceName} | Format-Table -Property Status, Name, DisplayName -Wrap -AutoSize
        } #end else
    } #end if (($WinSrvNumber -eq 1) -and ($Credential -eq $false))


   #Get service on multi computer with credentail
   if (($WinSrvNumber -gt 1) -and ($Credential -eq $true)){

        #WinCheckCred variable send value to Get-FormWinSvceDisplayOptions function to determine use credential or not
        $WinCheckCred=1
        
        #Call Get-Global:WinCredential function
        if ($Global:WinCredential -eq $null){
              Get-FormWinSvceCredential
        } #end  if ($Global:WinCredential -eq $null)

        #Get services based on function Get-FormWinSvceDisplayOptions
        if ($DisplayOptoins){
             #Call Function Get-FormWinSvceDisplayOptions
             $WinSvceProperty = Get-FormWinSvceDisplayOptions  
                  
             #Connect to each computer
             for ($counter=0; $counter -lt $WinSrvNumber; $counter++){
                  #Get services
                  Write-Output ("* Display services on computername: " + $ComputerName[$counter])
          
                  #Foreach to include server type into service details if checked
                  $WinGetSvc=@()
                  foreach ($WinSvceTypeTemp in $ServiceName){
                  $WinGetSvc+=Invoke-Command -ComputerName $ComputerName[$counter] -Credential $Global:WinCredential -ScriptBlock{Get-Service -Name $using:WinSvceTypeTemp} | Select-Object $WinSvceProperty
                  } #end  foreach ($WinSvceTypeTemp in $ServiceName)

                  #Display get services after choose concern display properties
                  $WinGetSvc |  Format-Table -Wrap -AutoSize
    
             } #end for ($counter=0; $counter -lt $WinSrvNumber; $counter)
        } #end if ($DisplayOptoins)

        else{
            #Connect to each computer
            for ($counter=0; $counter -lt $WinSrvNumber; $counter++){
                  #Get services
                  Write-Output ("* Display services on computername: " + $ComputerName[$counter])
                  Invoke-Command -ComputerName $ComputerName[$counter] -Credential $Global:WinCredential -ScriptBlock{Get-Service -Name $using:ServiceName} | Format-Table -Property Status, Name, DisplayName -Wrap -AutoSize
            } #end for ($counter=0; $counter -lt $WinSrvNumber; $counter)
        } #end else
    } #end if (($WinSrvNumber -gt 1) -and ($Credential -eq $true))


   #Get service on multi computer without credentail
   if (($WinSrvNumber -gt 1) -and ($Credential -eq $false)){

        #WinCheckCred variable send value to Get-FormWinSvceDisplayOptions function to determine use credential or not
        $WinCheckCred=0

        #Get services based on function Get-FormWinSvceDisplayOptions
        if ($DisplayOptoins){

             #Call Function Get-FormWinSvceDisplayOptions
             $WinSvceProperty = Get-FormWinSvceDisplayOptions  
                  
             #Connect to each computer
             for ($counter=0; $counter -lt $WinSrvNumber; $counter++){
                  #Get services
                  Write-Output ("* Display services on computername: " + $ComputerName[$counter])
          
                  #Foreach to include server type into service details if checked
                  $WinGetSvc=@()
                  foreach ($WinSvceTypeTemp in $ServiceName){
                  $WinGetSvc+=Invoke-Command -ComputerName $ComputerName[$counter] -ScriptBlock{Get-Service -Name $using:WinSvceTypeTemp} | Select-Object $WinSvceProperty
                  } #end  foreach ($WinSvceTypeTemp in $ServiceName)

                  #Display get services after choose concern display properties
                  $WinGetSvc |  Format-Table -Wrap -AutoSize

             } #end for ($counter=0; $counter -lt $WinSrvNumber; $counter)
        } #end if ($DisplayOptoins)

        else{
            #Connect to each computer
            for ($counter=0; $counter -lt $WinSrvNumber; $counter++){
                  #Get services
                  Write-Output ("* Display services on computername: " + $ComputerName[$counter])
                  Invoke-Command -ComputerName $ComputerName[$counter] -ScriptBlock{Get-Service -Name $using:ServiceName} | Format-Table -Property Status, Name, DisplayName -Wrap -AutoSize
            } #end for ($counter=0; $counter -lt $WinSrvNumber; $counter)
        } #end else
    } #end if (($WinSrvNumber -gt 1) -and ($Credential -eq $false))
    

   #Remove trusted hosts
   Clear-Item WSMan:\localhost\Client\TrustedHosts -Force

} #end Function Get-FormWinSvce


###########Get-FormWinSvceCredential Function###########
Function Get-FormWinSvceCredential {

$Global:WinCredential=Get-Credential -Credential 'Administrator'

} #end Function Get-FormWinSvceCredential


##########Get-FormWinSvceDisplayOptions Function########
Function Get-FormWinSvceDisplayOptions{

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
} #end Functoin Get-FormWinSvceDisplayOptions


###############Start-FormWinSvce Function################
Function Start-FormWinSvce {
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

        #Call Get-Global:WinCredential function
        if ($Global:WinCredential -eq $null){
              Get-FormWinSvceCredential
        } #end  if ($Global:WinCredential -eq $null)
 
        #At begin run required services
        if ($RequiredService){
    
            #Get required services
            $WinGetSvcDepedning=Invoke-Command -ComputerName $ComputerName -Credential $Global:WinCredential -ScriptBlock{Get-Service -Name $using:ServiceName}
            $WinArraySvcDepnding=$WinGetSvcDepedning.RequiredServices | Sort-Object -Unique
   
            Write-Output ("At begin it must run required services on computername: " + $ComputerName) 

            #Run required services
            $WinGetSvceList=@()
            Foreach ($WinSvceDependTemp in $WinArraySvcDepnding) {
              Invoke-Command -ComputerName $ComputerName -Credential $Global:WinCredential -ScriptBlock{Start-Service -Name $using:WinSvceDependTemp}
              $WinGetSvceList+=Invoke-Command -ComputerName $ComputerName -Credential $Global:WinCredential -ScriptBlock{Get-Service -Name $using:WinSvceDependTemp}
            } #end foreach ($WinSvceDependTemp in $WinArraySvcDepnding)

            $WinGetSvceList | Format-Table -Property Status, Name, DisplayName -Wrap -AutoSize
        } #end if ($RequiredService)

        #Run mentioned service
        Write-Output ("Run needed services on computername: " + $ComputerName)
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
   
            Write-Output ("At begin it must run required services on computername: " + $ComputerName)

            #Run required services
            $WinGetSvceList=@()
            Foreach ($WinSvceDependTemp in $WinArraySvcDepnding) {
              Invoke-Command -ComputerName $ComputerName -ScriptBlock{Start-Service -Name $using:WinSvceDependTemp}
              $WinGetSvceList+=Invoke-Command -ComputerName $ComputerName -ScriptBlock{Get-Service -Name $using:WinSvceDependTemp}
            } #end foreach ($WinSvceDependTemp in $WinArraySvcDepnding)

            $WinGetSvceList | Format-Table -Property Status, Name, DisplayName -Wrap -AutoSize
        } #end if ($RequiredService)

        #Run mentioned service
        Write-Output ("Run needed services on computername: " + $ComputerName)
        Invoke-Command -ComputerName $ComputerName -ScriptBlock{Start-Service -Name $using:ServiceName}
        Invoke-Command -ComputerName $ComputerName -ScriptBlock{Get-Service -Name $using:ServiceName} | Format-Table -Property Status, Name, DisplayName -Wrap -AutoSize
    } #end if (($WinSrvNumber -eq 1) -and ($Credential -eq $false))

    # Run service on multi computer with credential
    if (($WinSrvNumber -gt 1) -and ($Credential -eq $true)){
         
         #Call Get-Global:WinCredential function
         if ($Global:WinCredential -eq $null){
              Get-FormWinSvceCredential
         } #end  if ($Global:WinCredential -eq $null)

         #Connect to each computer
         for ($counter=0; $counter -lt $WinSrvNumber; $counter++){
            
            #At begin run required services
            if ($RequiredService){
                #get required services
                $WinArraySvcDepnding=$null

                $WinGetSvcDepedingSrv=Invoke-Command -ComputerName $ComputerName[$counter] -Credential $Global:WinCredential -ScriptBlock{Get-Service -Name $using:ServiceName}
                $WinArraySvcDepnding=$WinGetSvcDepedingSrv.RequiredServices | Sort-Object -Unique
                Write-Output ("At begin it must run required services on computername: " + $ComputerName[$counter])

                #Run required services
                $WinGetSvceList=@()
                Foreach ($WinSvceDependTemp in $WinArraySvcDepnding) {
                  Invoke-Command -ComputerName $ComputerName[$counter] -Credential $Global:WinCredential -ScriptBlock{Start-Service -Name $using:WinSvceDependTemp}
                  $WinGetSvceList+=Invoke-Command -ComputerName $ComputerName[$counter] -Credential $Global:WinCredential -ScriptBlock{Get-Service -Name $using:WinSvceDependTemp}
                } #end foreach ($WinSvceDependTemp in $WinArraySvcDepnding)
          
                  $WinArraySvcDepnding=$null
                  $WinGetSvceList | Format-Table -Property Status, Name, DisplayName -Wrap -AutoSize
            } #end if ($RequiredService)

            #Run mentioned service
             Write-Output ("Run needed services on computername: " + $ComputerName[$counter])
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
                Write-Output ("At begin it must run required services on computername: " + $ComputerName[$counter])

                #Run required services
                $WinGetSvceList=@()
                Foreach ($WinSvceDependTemp in $WinArraySvcDepnding) {
                  Invoke-Command -ComputerName $ComputerName[$counter] -ScriptBlock{Start-Service -Name $using:WinSvceDependTemp}
                  $WinGetSvceList+=Invoke-Command -ComputerName $ComputerName[$counter] -ScriptBlock{Get-Service -Name $using:WinSvceDependTemp}
                } #end foreach ($WinSvceDependTemp in $WinArraySvcDepnding)
          
                  $WinArraySvcDepnding=$null
                  $WinGetSvceList | Format-Table -Property Status, Name, DisplayName -Wrap -AutoSize
            } #end if ($RequiredService)

            #Run mentioned service
             Write-Output ("Run needed services on computername: " + $ComputerName[$counter])
             Invoke-Command -ComputerName $ComputerName[$counter] -ScriptBlock{Start-Service -Name $using:ServiceName}
             Invoke-Command -ComputerName $ComputerName[$counter] -ScriptBlock{Get-Service -Name $using:ServiceName} | Format-Table -Property Status, Name, DisplayName -Wrap -AutoSize

        } #end for ($counter=0; $counter -lt $WinSrvNumber; $counter)
    } #end if (($WinSrvNumber -gt 1) -and ($Credential -eq $false))

   #Remove trusted hosts
   Clear-Item WSMan:\localhost\Client\TrustedHosts -Force
       
} #end Function Start-FormWinSvce 


###############Stop-FormWinSvce Function################
Function Stop-FormWinSvce {
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

        #Call Get-Global:WinCredential function
        if ($Global:WinCredential -eq $null){
              Get-FormWinSvceCredential
        } #end  if ($Global:WinCredential -eq $null)

        #$Global:FormWinSvceCredential variable send value to Stop-FormWinSvceCanStop function to determine use credential or not
        $Global:FormWinSvceCredential=1
        
        #Call Function Stop-FormWinSvceCanStop 
        Stop-FormWinSvceCanStop -ComputerName $ComputerName -ServiceName $ServiceName -Credential $Global:WinCredential 
        $WinSvcFinal=@($Global:ServiceNameCanStop) 

        #At begin stop depending services
        if ($DependentServices){
    
            #Get depending services
            $WinGetSvcDepedning=Invoke-Command -ComputerName $ComputerName -Credential $Global:WinCredential -ScriptBlock{Get-Service -Name $using:WinSvcFinal}
            $WinArraySvcDepnding=$WinGetSvcDepedning.DependentServices | Sort-Object -Unique
   
            Write-Output ("At begin it must stop dependent services on computername: " + $ComputerName)

            #stop depending services
            $WinGetSvceList=@()
            Foreach ($WinSvceDependTemp in $WinArraySvcDepnding) {
              Invoke-Command -ComputerName $ComputerName -Credential $Global:WinCredential -ScriptBlock{Stop-Service -Name $using:WinSvceDependTemp}
              $WinGetSvceList+=Invoke-Command -ComputerName $ComputerName -Credential $Global:WinCredential -ScriptBlock{Get-Service -Name $using:WinSvceDependTemp}
            } #end foreach ($WinSvceDependTemp in $WinArraySvcDepnding)

            $WinGetSvceList | Format-Table -Property Status, Name, DisplayName -Wrap -AutoSize
        } #end if ($DependentServices)


        #If WinSvc include stop services
        if (($WinSvcFinal).count -gt 0){
            #Stop mentioned service
            Write-Output ("Stop needed services on computername: " + $ComputerName)
            Invoke-Command -ComputerName $ComputerName -Credential $Global:WinCredential -ScriptBlock{Stop-Service -Name $using:WinSvcFinal}
            Invoke-Command -ComputerName $ComputerName -Credential $Global:WinCredential -ScriptBlock{Get-Service -Name $using:WinSvcFinal} | Format-Table -Property Status, Name, DisplayName -Wrap -AutoSize
        } #end if (($WinSvcFinal).count -eq $null)

        else{
             Write-Output ("There isn't any services can stop on computername: " + $ComputerName)
        } #end else
        
    } #end if (($WinSrvNumber -eq 1) -and ($Credential -eq $true))

    #Stop service on one computer without credential 
    if (($WinSrvNumber -eq 1) -and ($Credential -eq $false)){

        #$Global:FormWinSvceCredential variable send value to Stop-FormWinSvceCanStop function to determine use credential or not
        $Global:FormWinSvceCredential=0

        #Call Function Stop-FormWinSvceCanStop
        Stop-FormWinSvceCanStop -ComputerName $ComputerName -ServiceName $ServiceName
        $WinSvcFinal=@($Global:ServiceNameCanStop) 

        #At begin stop depending services
        if ($DependentServices){
    
            #Get depending services
            $WinGetSvcDepedning=Invoke-Command -ComputerName $ComputerName -ScriptBlock{Get-Service -Name $using:WinSvcFinal}
            $WinArraySvcDepnding=$WinGetSvcDepedning.DependentServices | Sort-Object -Unique
   
            Write-Output ("At begin it must stop dependent services on computername: " + $ComputerName)

            #stop depending services
            $WinGetSvceList=@()
            Foreach ($WinSvceDependTemp in $WinArraySvcDepnding) {
              Invoke-Command -ComputerName $ComputerName -ScriptBlock{Stop-Service -Name $using:WinSvceDependTemp}
              $WinGetSvceList+=Invoke-Command -ComputerName $ComputerName -ScriptBlock{Get-Service -Name $using:WinSvceDependTemp}
            } #end foreach ($WinSvceDependTemp in $WinArraySvcDepnding)

            $WinGetSvceList | Format-Table -Property Status, Name, DisplayName -Wrap -AutoSize
        } #end if ($DependentServices)


        #If WinSvc include stop services
        if (($WinSvcFinal).count -gt 0){
            #Stop mentioned service
            Write-Output ("Stop needed services on computername: " + $ComputerName)
            Invoke-Command -ComputerName $ComputerName -ScriptBlock{Stop-Service -Name $using:WinSvcFinal}
            Invoke-Command -ComputerName $ComputerName -ScriptBlock{Get-Service -Name $using:WinSvcFinal} | Format-Table -Property Status, Name, DisplayName -Wrap -AutoSize
        } #end if (($WinSvcFinal).count -eq $null)

        else{
             Write-Output ("There isn't any services can stop on computername: " + $ComputerName)
        } #end else
        
    } #end if (($WinSrvNumber -eq 1) -and ($Credential -eq $false))
  
    #Stop service on multi computer with credential
    if (($WinSrvNumber -gt 1) -and ($Credential -eq $true)){

        #Call Get-Global:WinCredential function
        if ($Global:WinCredential -eq $null){
              Get-FormWinSvceCredential
        } #end  if ($Global:WinCredential -eq $null)

        #$Global:FormWinSvceCredential variable send value to Stop-FormWinSvceCanStop function to determine use credential or not
        $Global:FormWinSvceCredential=1
    
         #Connect to each computer
         for ($counter=0; $counter -lt $WinSrvNumber; $counter++){

            #Call Function Stop-FormWinSvceCanStop
            Stop-FormWinSvceCanStop -ComputerName $ComputerName[$counter] -ServiceName $ServiceName -Credential $Global:WinCredential
            $WinSvcFinal=@($Global:ServiceNameCanStop) 

            #At begin stop depending services
            if ($DependentServices){
                #get depending services
                $WinArraySvcDepnding=$null

                $WinGetSvcDepedingSrv=Invoke-Command -ComputerName $ComputerName[$counter] -Credential $Global:WinCredential -ScriptBlock{Get-Service -Name $using:WinSvcFinal}
                $WinArraySvcDepnding=$WinGetSvcDepedingSrv.DependentServices | Sort-Object -Unique
                Write-Output ("At begin it must stop dependent services on computername: " + $ComputerName[$counter])

                #Stop depending services
                $WinGetSvceList=@()
                Foreach ($WinSvceDependTemp in $WinArraySvcDepnding) {
                  Invoke-Command -ComputerName $ComputerName[$counter] -Credential $Global:WinCredential -ScriptBlock{Stop-Service -Name $using:WinSvceDependTemp}
                  $WinGetSvceList+=Invoke-Command -ComputerName $ComputerName[$counter] -Credential $Global:WinCredential -ScriptBlock{Get-Service -Name $using:WinSvceDependTemp}
                } #end foreach ($WinSvceDependTemp in $WinArraySvcDepnding)
          
                  $WinArraySvcDepnding=$null
                  $WinGetSvceList | Format-Table -Property Status, Name, DisplayName -Wrap -AutoSize
            } #end if ($DependentServices)
            
            #If WinSvc include services
            if (($WinSvcFinal).count -gt 0){

                #Stop mentioned service
                Write-Output ("Stop needed services on computername: " + $ComputerName[$counter])
                Invoke-Command -ComputerName $ComputerName[$counter] -Credential $Global:WinCredential -ScriptBlock{Stop-Service -Name $using:WinSvcFinal}
                Invoke-Command -ComputerName $ComputerName[$counter] -Credential $Global:WinCredential -ScriptBlock{Get-Service -Name $using:WinSvcFinal} | Format-Table -Property Status, Name, DisplayName -Wrap -AutoSize

             } #end if (($WinSvcFinal).count -eq $null)
             
            else{
                Write-Output ("There isn't any services can stop on computername: " + $ComputerName[$counter])
            } #end else
        } #end for ($counter=0; $counter -lt $WinSrvNumber; $counter)
    } #end if (($WinSrvNumber -gt 1) -and ($Credential -eq $true))

    #Stop service on multi computer without credential
    if (($WinSrvNumber -gt 1) -and ($Credential -eq $false)){
        
         #Connect to each computer
         for ($counter=0; $counter -lt $WinSrvNumber; $counter++){

            #$Global:FormWinSvceCredential variable send value to Stop-FormWinSvceCanStop function to determine use credential or not
            $Global:FormWinSvceCredential=0
            
            #Call Function Stop-FormWinSvceCanStop
            Stop-FormWinSvceCanStop -ComputerName $ComputerName[$counter] -ServiceName $ServiceName
            $WinSvcFinal=@($Global:ServiceNameCanStop) 

            #At begin stop depending services
            if ($DependentServices){
                #get depending services
                $WinArraySvcDepnding=$null

                $WinGetSvcDepedingSrv=Invoke-Command -ComputerName $ComputerName[$counter] -ScriptBlock{Get-Service -Name $using:WinSvcFinal}
                $WinArraySvcDepnding=$WinGetSvcDepedingSrv.DependentServices | Sort-Object -Unique
                Write-Output ("At begin it must stop dependent services on computername: " + $ComputerName[$counter])

                #Stop depending services
                $WinGetSvceList=@()
                Foreach ($WinSvceDependTemp in $WinArraySvcDepnding) {
                  Invoke-Command -ComputerName $ComputerName[$counter] -ScriptBlock{Stop-Service -Name $using:WinSvceDependTemp}
                  $WinGetSvceList+=Invoke-Command -ComputerName $ComputerName[$counter] -ScriptBlock{Get-Service -Name $using:WinSvceDependTemp}
                } #end foreach ($WinSvceDependTemp in $WinArraySvcDepnding)
          
                  $WinArraySvcDepnding=$null
                  $WinGetSvceList | Format-Table -Property Status, Name, DisplayName -Wrap -AutoSize
            } #end if ($DependentServices)
            
            #If WinSvc include services
            if (($WinSvcFinal).count -gt 0){

                #Stop mentioned service
                Write-Output ("Stop needed services on computername: " + $ComputerName[$counter])
                Invoke-Command -ComputerName $ComputerName[$counter] -ScriptBlock{Stop-Service -Name $using:WinSvcFinal}
                Invoke-Command -ComputerName $ComputerName[$counter] -ScriptBlock{Get-Service -Name $using:WinSvcFinal} | Format-Table -Property Status, Name, DisplayName -Wrap -AutoSize

             } #end if (($WinSvcFinal).count -eq $null)
             
            else{
                Write-Output ("There isn't any services can stop on computername: " + $ComputerName[$counter])
            } #end else
        } #end for ($counter=0; $counter -lt $WinSrvNumber; $counter)
    } #end if (($WinSrvNumber -gt 1) -and ($Credential -eq $false))

   #Remove trusted hosts
   Clear-Item WSMan:\localhost\Client\TrustedHosts -Force
         
} #end Function Stop-FormWinSvce


###############Stop-FormWinSvceCanStop Function################
Function Stop-FormWinSvceCanStop {
    param ($ComputerName,
          $ServiceName,
          [Switch]$Credential)

    #Set trusted hosts
    Set-Item WSMan:\localhost\Client\TrustedHosts –Value “*” -ea 0 -Force

    #Force array to accept one value or more
    [System.Collections.ArrayList]$WinSvceArray=@($ServiceName)

    #Verfiy invoke command with credential or not
    if ($Global:FormWinSvceCredential -eq 1){
          $WinGetSvce=Invoke-Command -ComputerName $ComputerName -Credential $Global:WinCredential -ScriptBlock{Get-Service -Name $using:WinSvceArray}
    } #end if ($Global:FormWinSvceCredential -eq 1)

    elseif ($Global:FormWinSvceCredential -eq 0){
        $WinGetSvce=Invoke-Command -ComputerName $ComputerName -ScriptBlock{Get-Service -Name $using:WinSvceArray}
    } #end elseif ($Global:FormWinSvceCredential -eq 0)

    $WinSvceNumber=($ServiceName).Count

    #Remove unable service to stop
    for ($counter=0; $counter -lt $WinSvceNumber; $counter++){
       if ($WinGetSvce[$counter].CanStop -eq $false){
            Write-Output ("The service name " + ($WinGetSvce[$counter]).DisplayName + " is unble to stop or already stopped before on computername:  $ComputerName")
            $WinSvceArray.Remove(($WinGetSvce[$counter]).Name)
       } #end if ($WinGetSvce[$counter].CanStop -eq $false)
    } #end for ($counter=0; $counter -lt $WinSvceNumber; $counter++)


     #Service name output
     $Global:ServiceNameCanStop=$WinSvceArray
} #end Function Stop-FormWinSvceCanStop


###############Resume-FormWinSvce Function################
Function Resume-FormWinSvce {
    param ($ComputerName,
           $ServiceName,
           [Switch]$Credential)

    #Set trusted hosts
    Set-Item WSMan:\localhost\Client\TrustedHosts –Value “*” -ea 0 -Force

    #Get number of computers
    $WinSrvNumber=($ComputerName).count

    #Resume service on one computer with credential
    if (($WinSrvNumber -eq 1) -and ($Credential -eq $true)){

            #Call Get-Global:WinCredential function
            if ($Global:WinCredential -eq $null){
                 Get-FormWinSvceCredential
            } #end  if ($Global:WinCredential -eq $null)

        
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
                     Write-Output ("It's unble to resume services name " + ($WinGetSvceCantResumeTemp).DisplayName + " on computername: " + $ComputerName)
                     $WinSvceName.Remove(($WinGetSvceCantResumeTemp).Name)
                } #end foreach ($WinGetSvceCantResumeTemp in $WinGetSvceCantResume)
            } #end if ($WinGetSvceResume -contains $false)
               

            if (($WinSvceName).Count -eq 0){
                 Write-Output ("There isn't any services able to resume on computername: " + $ComputerName) 
             } #end if (($WinSvceName).Count -eq 0)

            else{
                #Resume mentioned service
                Write-Output ("Resume needed services on computername: " + $ComputerName)
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
                     Write-Output ("It's unble to resume services name " + ($WinGetSvceCantResumeTemp).DisplayName + " on computername: " + $ComputerName)
                    $WinSvceName.Remove(($WinGetSvceCantResumeTemp).Name)
                } #end foreach ($WinGetSvceCantResumeTemp in $WinGetSvceCantResume)
            } #end if ($WinGetSvceResume -contains $false)
               

            if (($WinSvceName).Count -eq 0){
                 Write-Output ("There isn't any services able to resume on computername: " + $ComputerName) 
             } #end if (($WinSvceName).Count -eq 0)

            else{
                #Resume mentioned service
                Write-Output ("Resume needed services on computername: " + $ComputerName)
                Invoke-Command -ComputerName $ComputerName -ScriptBlock{Resume-Service -Name $using:WinSvceName}
                Invoke-Command -ComputerName $ComputerName -ScriptBlock{Get-Service -Name $using:WinSvceName} | Format-Table -Property Status, Name, DisplayName -Wrap -AutoSize
             } #end else

  
    } #end if (($WinSrvNumber -eq 1) -and ($Credential -eq $false))


    #Resume service on multi computer with credential
    if (($WinSrvNumber -gt 1) -and ($Credential -eq $true)){
            
            #Call Get-Global:WinCredential function
            if ($Global:WinCredential -eq $null){
                 Get-FormWinSvceCredential
            } #end  if ($Global:WinCredential -eq $null)


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
                         Write-Output ("It's unble to resume services name " + ($WinGetSvceCantResumeTemp).DisplayName + " on computername: " + $ComputerName[$counter])
                         $WinSvceName.Remove(($WinGetSvceCantResumeTemp).Name)
                    } #end foreach ($WinGetSvceCantResumeTemp in $WinGetSvceCantResume)
               
                 } #end if ($WinGetSvceResume -contains $false)

                if (($WinSvceName).Count -eq 0){
                     Write-Output ("There isn't any services able to resume on computername: " + $ComputerName[$counter]) 
                 } #end if (($WinSvceName).Count -eq 0)

                else{
                    #Resume mentioned service
                    Write-Output ("Resume needed services on computername: " + $ComputerName[$counter])
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
                         Write-Output ("It's unble to resume services name " + ($WinGetSvceCantResumeTemp).DisplayName + " on computername: " + $ComputerName[$counter])
                         $WinSvceName.Remove(($WinGetSvceCantResumeTemp).Name)
                    } #end foreach ($WinGetSvceCantResumeTemp in $WinGetSvceCantResume)
               
                 } #end if ($WinGetSvceResume -contains $false)

                if (($WinSvceName).Count -eq 0){
                     Write-Output ("There isn't any services able to resume on computername: " + $ComputerName[$counter]) 
                 } #end if (($WinSvceName).Count -eq 0)

                else{
                    #Resume mentioned service
                    Write-Output ("Resume needed services on computername: " + $ComputerName[$counter])
                    Invoke-Command -ComputerName $ComputerName[$counter] -ScriptBlock{Resume-Service -Name $using:WinSvceName}
                    Invoke-Command -ComputerName $ComputerName[$counter] -ScriptBlock{Get-Service -Name $using:WinSvceName} | Format-Table -Property Status, Name, DisplayName -Wrap -AutoSize
                 } #end else

        } # end for ($counter=0; $counter -lt $WinSrvNumber; $counter++)
    } #end if (($WinSrvNumber -gt 1) -and ($Credential -eq $false))

    #Remove trusted hosts
    Clear-Item WSMan:\localhost\Client\TrustedHosts -Force
         
} #end Function Resume-FormWinSvce


###############Pause-FormWinSvce Function###############
Function Pause-FormWinSvce {
    param ($ComputerName,
           $ServiceName,
           [Switch]$Credential)


    #Set trusted hosts
    Set-Item WSMan:\localhost\Client\TrustedHosts –Value “*” -ea 0 -Force

    #Get number of computers
    $WinSrvNumber=($ComputerName).count

    #Pause service on one computer with credential
    if (($WinSrvNumber -eq 1) -and ($Credential -eq $true)){

            #Call Get-Global:WinCredential function
            if ($Global:WinCredential -eq $null){
                 Get-FormWinSvceCredential
            } #end  if ($Global:WinCredential -eq $null)

        
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
                     Write-Output ("It's unble to pause services name " + ($WinGetSvceCantPauseTemp).DisplayName + " on computername: " + $ComputerName)
                     $WinSvceName.Remove(($WinGetSvceCantPauseTemp).Name)
                } #end foreach ($WinGetSvceCantPauseTemp in $WinGetSvceCantPause)
            } #end if ($WinGetSvcePause -contains $false)
               

            if (($WinSvceName).Count -eq 0){
                 Write-Output ("There isn't any services able to pause on computername: " + $ComputerName) 
             } #end if (($WinSvceName).Count -eq 0)

            else{
                #Pause mentioned service
                Write-Output ("Pause needed services on computername: " + $ComputerName)
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
                     Write-Output ("It's unble to pause services name " + ($WinGetSvceCantPauseTemp).DisplayName + " on computername: " + $ComputerName)
                     $WinSvceName.Remove(($WinGetSvceCantPauseTemp).Name)
                } #end foreach ($WinGetSvceCantPauseTemp in $WinGetSvceCantPause)
            } #end if ($WinGetSvcePause -contains $false)
               

            if (($WinSvceName).Count -eq 0){
                 Write-Output ("There isn't any services able to pause on computername: " + $ComputerName)
             } #end if (($WinSvceName).Count -eq 0)

            else{
                #Pause mentioned service
                Write-Output ("Pause needed services on computername: " + $ComputerName)
                Invoke-Command -ComputerName $ComputerName -ScriptBlock{Suspend-Service -Name $using:WinSvceName}
                Invoke-Command -ComputerName $ComputerName -ScriptBlock{Get-Service -Name $using:WinSvceName} | Format-Table -Property Status, Name, DisplayName -Wrap -AutoSize
             } #end else

  
    } #end if (($WinSrvNumber -eq 1) -and ($Credential -eq $false))

    #Pause service on multi computer with credential
    if (($WinSrvNumber -gt 1) -and ($Credential -eq $true)){
            
            #Call Get-Global:WinCredential function
            if ($Global:WinCredential -eq $null){
                 Get-FormWinSvceCredential
            } #end  if ($Global:WinCredential -eq $null)

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
                         Write-Output ("It's unble to pause services name " + ($WinGetSvceCantPauseTemp).DisplayName + " on computername: " + $ComputerName[$counter])
                        $WinSvceName.Remove(($WinGetSvceCantPauseTemp).Name)
                    } #end foreach ($WinGetSvceCantPauseTemp in $WinGetSvceCantPause)
               
                 } #end if ($WinGetSvcePause -contains $false)

                if (($WinSvceName).Count -eq 0){
                     Write-Output ("There isn't any services able to pause on computername: " + $ComputerName[$counter])
                 } #end if (($WinSvceName).Count -eq 0)

                else{
                    #Pause mentioned service
                    Write-Output ("Pause needed services on computername: " + $ComputerName[$counter])
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
                     Write-Output ("It's unble to pause services name " + ($WinGetSvceCantPauseTemp).DisplayName + " on computername: " + $ComputerName[$counter])
                     $WinSvceName.Remove(($WinGetSvceCantPauseTemp).Name)
                } #end foreach ($WinGetSvceCantPauseTemp in $WinGetSvceCantPause)
               
             } #end if ($WinGetSvcePause -contains $false)

            if (($WinSvceName).Count -eq 0){
                 Write-Output ("There isn't any services able to pause on computername: " + $ComputerName[$counter])
             } #end if (($WinSvceName).Count -eq 0)

            else{
                #Pause mentioned service
                Write-Output ("Pause needed services on computername: " + $ComputerName[$counter])
                Invoke-Command -ComputerName $ComputerName[$counter] -ScriptBlock{Suspend-Service -Name $using:WinSvceName}
                Invoke-Command -ComputerName $ComputerName[$counter] -ScriptBlock{Get-Service -Name $using:WinSvceName} | Format-Table -Property Status, Name, DisplayName -Wrap -AutoSize
             } #end else

        } # end for ($counter=0; $counter -lt $WinSrvNumber; $counter++)
    } #end if (($WinSrvNumber -gt 1) -and ($Credential -eq $false))

   #Remove trusted hosts
   Clear-Item WSMan:\localhost\Client\TrustedHosts -Force
         
} #end Function Pause-FormWinSvce


###############Restart-FormWinSvce Function###############
Function Restart-FormWinSvce {
    param ($ComputerName,
           $ServiceName,
           [Switch]$Credential)

    #Set trusted hosts
    Set-Item WSMan:\localhost\Client\TrustedHosts –Value “*” -ea 0 -Force

    #Get number of computers
    $WinSrvNumber=($ComputerName).count

    #Restart service on one computer with credential
    if (($WinSrvNumber -eq 1) -and ($Credential -eq $true)){

            #Call Get-Global:WinCredential function
            if ($Global:WinCredential -eq $null){
                 Get-FormWinSvceCredential
            } #end  if ($Global:WinCredential -eq $null)

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
                     Write-Output ("It's unble to restart services name " + ($WinGetSvceCantRestartTemp).DisplayName + " on computername: " + $ComputerName)
                     $WinSvceName.Remove(($WinGetSvceCantRestartTemp).Name)
                } #end foreach ($WinGetSvceCantRestartTemp in $WinGetSvceCantRestart)
            } #end if ($WinGetSvceRestart -contains $false)
               

            if (($WinSvceName).Count -eq 0){
                 Write-Output ("There isn't any services able to restart on computername: " + $ComputerName)
             } #end if (($WinSvceName).Count -eq 0)

            else{
                #Restart mentioned service
                Write-Output ("`n" + "Restart needed services on computername: " + $ComputerName)
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
                     Write-Output ("It's unble to restart services name " + ($WinGetSvceCantRestartTemp).DisplayName + " on computername: " + $ComputerName)
                    $WinSvceName.Remove(($WinGetSvceCantRestartTemp).Name)
                } #end foreach ($WinGetSvceCantRestartTemp in $WinGetSvceCantRestart)
            } #end if ($WinGetSvceRestart -contains $false)
               

            if (($WinSvceName).Count -eq 0){
                 Write-Output ("There isn't any services able to restart on computername: " + $ComputerName)
             } #end if (($WinSvceName).Count -eq 0)

            else{
                #Restart mentioned service
                Write-Output ("Restart needed services on computername: " + $ComputerName)
                Invoke-Command -ComputerName $ComputerName -ScriptBlock{Restart-Service -Name $using:WinSvceName}
                Invoke-Command -ComputerName $ComputerName -ScriptBlock{Get-Service -Name $using:WinSvceName} | Format-Table -Property Status, Name, DisplayName -Wrap -AutoSize
             } #end else

    } #end if (($WinSrvNumber -eq 1) -and ($Credential -eq $false))


    #Restart service on multi computer with credential
    if (($WinSrvNumber -gt 1) -and ($Credential -eq $true)){
            
            #Call Get-Global:WinCredential function
            if ($Global:WinCredential -eq $null){
                 Get-FormWinSvceCredential
            } #end  if ($Global:WinCredential -eq $null)

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
                         Write-Output ("It's unble to restart services name " + ($WinGetSvceCantRestartTemp).DisplayName + " on computername: " + $ComputerName[$counter])
                        $WinSvceName.Remove(($WinGetSvceCantRestartTemp).Name)
                    } #end foreach ($WinGetSvceCantRestartTemp in $WinGetSvceCantRestart)
               
                 } #end if ($WinGetSvceRestart -contains $false)

                if (($WinSvceName).Count -eq 0){
                     Write-Output ("There isn't any services able to restart on computername: " + $ComputerName[$counter])
                 } #end if (($WinSvceName).Count -eq 0)

                else{
                    #Restart mentioned service
                    Write-Output ("Restart needed services on computername: " + $ComputerName[$counter])
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
                         Write-Output ("It's unble to restart services name " + ($WinGetSvceCantRestartTemp).DisplayName + " on computername: " + $ComputerName[$counter])
                        $WinSvceName.Remove(($WinGetSvceCantRestartTemp).Name)
                    } #end foreach ($WinGetSvceCantRestartTemp in $WinGetSvceCantRestart)
               
                 } #end if ($WinGetSvceRestart -contains $false)

                if (($WinSvceName).Count -eq 0){
                     Write-Host ("There isn't any services able to restart on computername: " + $ComputerName[$counter])
                 } #end if (($WinSvceName).Count -eq 0)

                else{
                    #Restart mentioned service
                    Write-Output ("`n" + "Restart needed services on computername: " + $ComputerName[$counter])
                    Invoke-Command -ComputerName $ComputerName[$counter] -ScriptBlock{Restart-Service -Name $using:WinSvceName}
                    Invoke-Command -ComputerName $ComputerName[$counter] -ScriptBlock{Get-Service -Name $using:WinSvceName} | Format-Table -Property Status, Name, DisplayName -Wrap -AutoSize
                 } #end else

        } # end for ($counter=0; $counter -lt $WinSrvNumber; $counter++)
    } #end if (($WinSrvNumber -gt 1) -and ($Credential -eq $false))

    #Remove trusted hosts
    Clear-Item WSMan:\localhost\Client\TrustedHosts -Force
         
} #end Function Restart-FormWinSvce


###############Show-FormWinSvce Function################
function Show-FormWinSvce {
    
    #region Import the Assemblies
    [void][reflection.assembly]::Load('System.Windows.Forms, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
	[void][reflection.assembly]::Load('System.Data, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
	[void][reflection.assembly]::Load('System.Drawing, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')

	#0 FormWinSvce
	$FormWinSvce = New-Object 'System.Windows.Forms.Form'
	$FormWinSvce.AutoScaleDimensions = '6, 13'
	$FormWinSvce.AutoScaleMode = 'Font'
	$FormWinSvce.BackColor = 'Control'
	$FormWinSvce.ClientSize = '918, 385'
	$FormWinSvce.Name = 'FormWinSvce'
	$FormWinSvce.Text = 'Form WinSvce'

##################Service Operation Panel###########################

	#01 labelWinSvceOperation
	$labelWinSvceOperation = New-Object 'System.Windows.Forms.Label'
	$labelWinSvceOperation.AutoSize = $True
	$labelWinSvceOperation.Font = 'Microsoft Sans Serif, 8.25pt, style=Bold'
	$labelWinSvceOperation.Location = '20, 4'
	$labelWinSvceOperation.Name = 'labelWinSvceOperation'
	$labelWinSvceOperation.Size = '117, 13'
	$labelWinSvceOperation.TabIndex = 0
	$labelWinSvceOperation.Text = 'WinSvce Operation'

	#02 PanelWinSvceOpe
	$PanelWinSvceOpe = New-Object 'System.Windows.Forms.Panel'
	$PanelWinSvceOpe.BackColor = 'InactiveBorder'
	$PanelWinSvceOpe.BorderStyle = 'FixedSingle'
	$PanelWinSvceOpe.Location = '12, 12'
	$PanelWinSvceOpe.Name = 'WinSvceOpePanel'
	$PanelWinSvceOpe.Size = '894, 31'
	$PanelWinSvceOpe.TabIndex = 0

	#021 radiobuttonGetService
	$radiobuttonGetService = New-Object 'System.Windows.Forms.RadioButton'
	$radiobuttonGetService.Location = '15, 4'
	$radiobuttonGetService.Name = 'radiobuttonGetService'
	$radiobuttonGetService.Size = '104, 24'
	$radiobuttonGetService.TabIndex = 1
	$radiobuttonGetService.TabStop = $True
	$radiobuttonGetService.Text = 'Get Service'
	$radiobuttonGetService.UseVisualStyleBackColor = $True
    $radiobuttonGetService.add_CheckedChanged({	$panelStartService.Visible = $False
	                                            $panelStopService.Visible = $False
	                                            $panelResumeService.Visible = $False
	                                            $panelPauseService.Visible = $False
	                                            $panelRestartService.Visible = $False	
                                                $panelGetService.Visible = $True})

	#022 radiobuttonStartService
	$radiobuttonStartService = New-Object 'System.Windows.Forms.RadioButton'
	$radiobuttonStartService.Location = '154, 4'
	$radiobuttonStartService.Name = 'radiobuttonStartService'
	$radiobuttonStartService.Size = '104, 24'
	$radiobuttonStartService.TabIndex = 20
	$radiobuttonStartService.TabStop = $True
	$radiobuttonStartService.Text = 'Start Service'
	$radiobuttonStartService.UseVisualStyleBackColor = $True
    $radiobuttonStartService.add_CheckedChanged({ $panelStopService.Visible = $False
	                                              $panelResumeService.Visible = $False
	                                              $panelPauseService.Visible = $False
	                                              $panelRestartService.Visible = $False	
                                                  $panelGetService.Visible = $False
    	                                          $panelStartService.Visible = $True})

	#023 radiobuttonStopService
	$radiobuttonStopService = New-Object 'System.Windows.Forms.RadioButton'
	$radiobuttonStopService.Location = '299, 4'
	$radiobuttonStopService.Name = 'radiobuttonStopService'
	$radiobuttonStopService.Size = '104, 24'
	$radiobuttonStopService.TabIndex = 20
	$radiobuttonStopService.TabStop = $True
	$radiobuttonStopService.Text = 'Stop Service'
	$radiobuttonStopService.UseVisualStyleBackColor = $True
    $radiobuttonStopService.add_CheckedChanged({ $panelResumeService.Visible = $False
	                                             $panelPauseService.Visible = $False
	                                             $panelRestartService.Visible = $False	
                                                 $panelGetService.Visible = $False
                                                 $panelStartService.Visible = $False
    	                                         $panelStopService.Visible = $True})
    
	#024 radiobuttonResumeService
	$radiobuttonResumeService = New-Object 'System.Windows.Forms.RadioButton'
	$radiobuttonResumeService.Location = '447, 4'
	$radiobuttonResumeService.Name = 'radiobuttonResumeService'
	$radiobuttonResumeService.Size = '120, 24'
	$radiobuttonResumeService.TabIndex = 20
	$radiobuttonResumeService.TabStop = $True
	$radiobuttonResumeService.Text = 'Resume Service'
	$radiobuttonResumeService.UseVisualStyleBackColor = $True
    $radiobuttonResumeService.add_CheckedChanged({ $panelPauseService.Visible = $False
	                                               $panelRestartService.Visible = $False	
                                                   $panelGetService.Visible = $False
                                                   $panelStartService.Visible = $False
    	                                           $panelStopService.Visible = $False
    	                                           $panelResumeService.Visible = $True})

	#025 radiobuttonPauseService
	$radiobuttonPauseService = New-Object 'System.Windows.Forms.RadioButton'
	$radiobuttonPauseService.Location = '615, 4'
	$radiobuttonPauseService.Name = 'radiobuttonPauseService'
	$radiobuttonPauseService.Size = '104, 24'
	$radiobuttonPauseService.TabIndex = 20
	$radiobuttonPauseService.TabStop = $True
	$radiobuttonPauseService.Text = 'Pause Service'
	$radiobuttonPauseService.UseVisualStyleBackColor = $True
    $radiobuttonPauseService.add_CheckedChanged({ $panelRestartService.Visible = $False	
                                                  $panelGetService.Visible = $False
                                                  $panelStartService.Visible = $False
    	                                          $panelStopService.Visible = $False
    	                                          $panelResumeService.Visible = $False
    	                                          $panelPauseService.Visible = $True})
    
	#026 radiobuttonRestartService
	$radiobuttonRestartService = New-Object 'System.Windows.Forms.RadioButton'
	$radiobuttonRestartService.Location = '781, 4'
	$radiobuttonRestartService.Name = 'radiobuttonRestartService'
	$radiobuttonRestartService.Size = '104, 24'
	$radiobuttonRestartService.TabIndex = 20
	$radiobuttonRestartService.TabStop = $True
	$radiobuttonRestartService.Text = 'Restart Service'
	$radiobuttonRestartService.UseVisualStyleBackColor = $True
    $radiobuttonRestartService.add_CheckedChanged({ $panelGetService.Visible = $False
                                                    $panelStartService.Visible = $False
    	                                            $panelStopService.Visible = $False
    	                                            $panelResumeService.Visible = $False
    	                                            $panelPauseService.Visible = $False
    	                                            $panelRestartService.Visible = $True})	

##################Required Information Panel###########################

	#03 labelRequiredInformation
	$labelRequiredInformation = New-Object 'System.Windows.Forms.Label'
	$labelRequiredInformation.AutoSize = $True
	$labelRequiredInformation.Font = 'Microsoft Sans Serif, 8.25pt, style=Bold'
	$labelRequiredInformation.Location = '625, 57'
	$labelRequiredInformation.Name = 'labelRequiredInformation'
	$labelRequiredInformation.Size = '125, 13'
	$labelRequiredInformation.TabIndex = 0
	$labelRequiredInformation.Text = 'Required Information'

	#04 panelRequiredInformation
	$panelRequiredInformation = New-Object 'System.Windows.Forms.Panel'
	$panelRequiredInformation.BackColor = 'InactiveBorder'
	$panelRequiredInformation.BorderStyle = 'FixedSingle'
	$panelRequiredInformation.Location = '611, 65'
	$panelRequiredInformation.Name = 'panelRequiredInformation'
	$panelRequiredInformation.Size = '295, 125'
	$panelRequiredInformation.TabIndex = 0

	#041 labelEnterComputerNames
	$labelEnterComputerNames = New-Object 'System.Windows.Forms.Label'
	$labelEnterComputerNames.AutoSize = $True
	$labelEnterComputerNames.Font = 'Microsoft Sans Serif, 8.25pt'
	$labelEnterComputerNames.Location = '14, 15'
	$labelEnterComputerNames.Name = 'labelEnterCompterNames'
	$labelEnterComputerNames.Size = '110, 13'
	$labelEnterComputerNames.TabIndex = 0
	$labelEnterComputerNames.Text = 'Enter Computer Names'

	#042 textboxComputerName
	$textboxComputerName = New-Object 'System.Windows.Forms.TextBox'
	$textboxComputerName.Location = '16, 32'
	$textboxComputerName.Name = 'textboxComputerName'
	$textboxComputerName.Size = '262, 20'
	$textboxComputerName.TabIndex = 1

	#043 labelEnterServiceNames
	$labelEnterServiceNames = New-Object 'System.Windows.Forms.Label'
	$labelEnterServiceNames.AutoSize = $True
	$labelEnterServiceNames.Font = 'Microsoft Sans Serif, 8.25pt'
	$labelEnterServiceNames.Location = '14, 68'
	$labelEnterServiceNames.Name = 'labelEnterServiceNames'
	$labelEnterServiceNames.Size = '105, 13'
	$labelEnterServiceNames.TabIndex = 0
	$labelEnterServiceNames.Text = 'Enter Service names'

	#044 textboxServiceName
	$textboxServiceName = New-Object 'System.Windows.Forms.TextBox'
	$textboxServiceName.Location = '16, 85'
	$textboxServiceName.Name = 'textboxServiceName'
	$textboxServiceName.Size = '262, 20'
	$textboxServiceName.TabIndex = 2

##################Output#################################

	#05 labelOutput
	$labelOutput = New-Object 'System.Windows.Forms.Label'
	$labelOutput.AutoSize = $True
	$labelOutput.Font = 'Microsoft Sans Serif, 8.25pt, style=Bold'
	$labelOutput.Location = '24, 54'
	$labelOutput.Name = 'labelOutput'
	$labelOutput.Size = '45, 13'
	#$labelOutput.TabIndex = 0
	$labelOutput.Text = 'Output'

	#06 textboxOutput
	$textboxOutput = New-Object 'System.Windows.Forms.TextBox'
	$textboxOutput.BackColor = 'InactiveBorder'
	$textboxOutput.Font = 'Consolas, 8.25pt'
    $textboxOutput.ForeColor='DarkBlue'
    $textboxOutput.WordWrap= $False
	$textboxOutput.Location = '12, 65'
	$textboxOutput.Multiline = $True
	$textboxOutput.ReadOnly = $True
	$textboxOutput.Name = 'textboxOutput'
	$textboxOutput.MaxLength = 999999999
	$textboxOutput.ScrollBars = 'Both'
	$textboxOutput.Size = '588, 302'
	#$textboxOutput.TabIndex = 0

####################Get Service Panel############################

	#07 panelGetService
	$panelGetService = New-Object 'System.Windows.Forms.Panel'
	$panelGetService.BackColor = 'InactiveBorder'
	$panelGetService.BorderStyle = 'FixedSingle'
	$panelGetService.Location = '612, 198'
	$panelGetService.Name = 'panelGetService'
	$panelGetService.Size = '294, 168'
	$panelGetService.TabIndex = 0
    $panelGetService.Visible = $False
    
	#071 labelGetServiceOptions
	$labelGetServiceOptions = New-Object 'System.Windows.Forms.Label'
	$labelGetServiceOptions.AutoSize = $True
	$labelGetServiceOptions.Font = 'Microsoft Sans Serif, 8.25pt, style=Bold'
	$labelGetServiceOptions.Location = '13, 11'
	$labelGetServiceOptions.Name = 'labelGetServiceOptions'
	$labelGetServiceOptions.Size = '121, 13'
	$labelGetServiceOptions.TabIndex = 0
	$labelGetServiceOptions.Text = 'Get Service Options'

	#072 checkboxEnterCredentialGetService
	$checkboxEnterCredentialGetService = New-Object 'System.Windows.Forms.CheckBox'
	$checkboxEnterCredentialGetService.Location = '16, 70'
	$checkboxEnterCredentialGetService.Name = 'checkboxEnterCredentialGetService'
	$checkboxEnterCredentialGetService.Size = '350, 24'
	$checkboxEnterCredentialGetService.TabIndex = 4
	$checkboxEnterCredentialGetService.Text = 'Enter Credential'
	$checkboxEnterCredentialGetService.UseVisualStyleBackColor = $True

	#073 checkboxDisplayOptionsGetService
	$checkboxDisplayOptionsGetService = New-Object 'System.Windows.Forms.CheckBox'
	$checkboxDisplayOptionsGetService.Location = '16, 38'
	$checkboxDisplayOptionsGetService.Name = 'checkboxDisplayOptionsGetService'
	$checkboxDisplayOptionsGetService.Size = '104, 24'
	$checkboxDisplayOptionsGetService.TabIndex = 3
	$checkboxDisplayOptionsGetService.Text = 'Display options'
	$checkboxDisplayOptionsGetService.UseVisualStyleBackColor = $True

	#074 buttonRunGetService
	$buttonRunGetService = New-Object 'System.Windows.Forms.Button'
	$buttonRunGetService.Location = '13, 110'
	$buttonRunGetService.Name = 'buttonRunGetService'
	$buttonRunGetService.Size = '125, 23'
	$buttonRunGetService.TabIndex = 5
	$buttonRunGetService.Text = 'Run'
	$buttonRunGetService.UseVisualStyleBackColor = $True

	#075 buttonClearGetService
	$buttonClearGetService = New-Object 'System.Windows.Forms.Button'
	$buttonClearGetService.Location = '153, 110'
	$buttonClearGetService.Name = 'buttonClearGetService'
	$buttonClearGetService.Size = '125, 23'
	$buttonClearGetService.TabIndex = 6
	$buttonClearGetService.Text = 'Clear'
	$buttonClearGetService.UseVisualStyleBackColor = $True
    $buttonClearGetService.add_Click({ $textboxComputerName.Text = $null
                                       $textboxServiceName.Text = $null
                                       $textboxOutput.Text = $null
                                       $Global:WinCredential = $null
                                       $checkboxEnterCredentialGetService.Checked = $False
                                       $checkboxDisplayOptionsGetService.Checked = $False })

###################Start Service Panel##############################

	#08 panelStartService
	$panelStartService = New-Object 'System.Windows.Forms.Panel'
	$panelStartService.BackColor = 'InactiveBorder'
	$panelStartService.BorderStyle = 'FixedSingle'
    $panelStartService.Location = '612, 198'
	$panelStartService.Name = 'panelStartService'
	$panelStartService.Size = '294, 168'
	$panelStartService.TabIndex = 0
    $panelStartService.Visible = $False

	#081 labelStartServiceOptions
	$labelStartServiceOptions = New-Object 'System.Windows.Forms.Label'
	$labelStartServiceOptions.AutoSize = $True
	$labelStartServiceOptions.Font = 'Microsoft Sans Serif, 8.25pt, style=Bold'
	$labelStartServiceOptions.Location = '13, 11'
	$labelStartServiceOptions.Name = 'labelStartServiceOptions'
	$labelStartServiceOptions.Size = '128, 13'
	$labelStartServiceOptions.TabIndex = 0
	$labelStartServiceOptions.Text = 'Start Service Options'

	#082 checkboxRequiredServiceStartService
	$checkboxRequiredServiceStartService = New-Object 'System.Windows.Forms.CheckBox'
	$checkboxRequiredServiceStartService.Location = '16, 38'
	$checkboxRequiredServiceStartService.Name = 'checkboxRequiredServiceStartService'
	$checkboxRequiredServiceStartService.Size = '194, 24'
	$checkboxRequiredServiceStartService.TabIndex = 9
	$checkboxRequiredServiceStartService.Text = 'Start Required Services'
	$checkboxRequiredServiceStartService.UseVisualStyleBackColor = $True

	#083 checkboxEnterCredentialStartService
	$checkboxEnterCredentialStartService = New-Object 'System.Windows.Forms.CheckBox'
	$checkboxEnterCredentialStartService.Location = '16, 70'
	$checkboxEnterCredentialStartService.Name = 'checkboxEnterCredentialStartService'
	$checkboxEnterCredentialStartService.Size = '350, 24'
	$checkboxEnterCredentialStartService.TabIndex = 10
	$checkboxEnterCredentialStartService.Text = 'Enter Credential'
	$checkboxEnterCredentialStartService.UseVisualStyleBackColor = $True

	#084 buttonRunStartService
	$buttonRunStartService = New-Object 'System.Windows.Forms.Button'
	$buttonRunStartService.Location = '13, 110'
	$buttonRunStartService.Name = 'buttonRunStartService'
	$buttonRunStartService.Size = '125, 23'
	$buttonRunStartService.TabIndex = 11
	$buttonRunStartService.Text = 'Run'
	$buttonRunStartService.UseVisualStyleBackColor = $True

	#085 buttonClearStartService
	$buttonClearStartService = New-Object 'System.Windows.Forms.Button'
	$buttonClearStartService.Location = '153, 110'
	$buttonClearStartService.Name = 'buttonClearStartService'
	$buttonClearStartService.Size = '125, 23'
	$buttonClearStartService.TabIndex = 12
	$buttonClearStartService.Text = 'Clear'
	$buttonClearStartService.UseVisualStyleBackColor = $True
    $buttonClearStartService.add_Click({ $textboxComputerName.Text = $null
                                         $textboxServiceName.Text = $null
                                         $textboxOutput.Text = $null
                                         $Global:WinCredential = $null
                                         $checkboxEnterCredentialStartService.Checked = $False
                                         $checkboxRequiredServiceStartService.Checked = $False})

######################Stop Service Panel################################

	#09 panelStopService
	$panelStopService = New-Object 'System.Windows.Forms.Panel'
	$panelStopService.BackColor = 'InactiveBorder'
	$panelStopService.BorderStyle = 'FixedSingle'
	$panelStopService.Location = '612, 198'
	$panelStopService.Name = 'panelStopService'
	$panelStopService.Size = '294, 168'
	$panelStopService.TabIndex = 0
    $panelStopService.Visible = $False

	#091 labelStopServiceOptions
	$labelStopServiceOptions = New-Object 'System.Windows.Forms.Label'
	$labelStopServiceOptions.AutoSize = $True
	$labelStopServiceOptions.Font = 'Microsoft Sans Serif, 8.25pt, style=Bold'
	$labelStopServiceOptions.Location = '13, 11'
	$labelStopServiceOptions.Name = 'labelStopServiceOptions'
	$labelStopServiceOptions.Size = '127, 13'
	$labelStopServiceOptions.TabIndex = 0
	$labelStopServiceOptions.Text = 'Stop Service Options'

	#092 checkboxDependentServicesStopService
	$checkboxDependentServicesStopService = New-Object 'System.Windows.Forms.CheckBox'
	$checkboxDependentServicesStopService.Location = '16, 38'
	$checkboxDependentServicesStopService.Name = 'checkboxDependentServicesStopService'
	$checkboxDependentServicesStopService.Size = '194, 24'
	$checkboxDependentServicesStopService.TabIndex = 9
	$checkboxDependentServicesStopService.Text = 'Stop Dependent Services'
	$checkboxDependentServicesStopService.UseVisualStyleBackColor = $True

	#092 checkboxEnterCredentialStopService
	$checkboxEnterCredentialStopService = New-Object 'System.Windows.Forms.CheckBox'
	$checkboxEnterCredentialStopService.Location = '16, 70'
	$checkboxEnterCredentialStopService.Name = 'checkboxEnterCredentialStopService'
	$checkboxEnterCredentialStopService.Size = '350, 24'
	$checkboxEnterCredentialStopService.TabIndex = 10
	$checkboxEnterCredentialStopService.Text = 'Enter Credential'
	$checkboxEnterCredentialStopService.UseVisualStyleBackColor = $True

	#093 buttonRunStopService
	$buttonRunStopService = New-Object 'System.Windows.Forms.Button'
	$buttonRunStopService.Location = '13, 110'
	$buttonRunStopService.Name = 'buttonRunStopService'
	$buttonRunStopService.Size = '125, 23'
	$buttonRunStopService.TabIndex = 12
	$buttonRunStopService.Text = 'Run'
	$buttonRunStopService.UseVisualStyleBackColor = $True

	#094 buttonClearStopService
	$buttonClearStopService = New-Object 'System.Windows.Forms.Button'
	$buttonClearStopService.Location = '153, 110'
	$buttonClearStopService.Name = 'buttonClearStopService'
	$buttonClearStopService.Size = '125, 23'
	$buttonClearStopService.TabIndex = 13
	$buttonClearStopService.Text = 'Clear'
	$buttonClearStopService.UseVisualStyleBackColor = $True
    $buttonClearStopService.add_Click({ $textboxComputerName.Text = $null
                                        $textboxServiceName.Text = $null
                                        $textboxOutput.Text = $null
                                        $Global:WinCredential = $null
                                        $checkboxEnterCredentialStopService.Checked = $False
                                        $checkboxDependentServicesStopService.Checked = $False})

########################Resume Service Panel###############################

	#010 panelResumeService
	$panelResumeService = New-Object 'System.Windows.Forms.Panel'
	$panelResumeService.BackColor = 'InactiveBorder'
	$panelResumeService.BorderStyle = 'FixedSingle'
	$panelResumeService.Location = '612, 198'
	$panelResumeService.Name = 'panelResumeService'
	$panelResumeService.Size = '294, 168'
	$panelResumeService.TabIndex = 0
    $panelResumeService.Visible = $False

    #0101 labelResumeServiceOptions
	$labelResumeServiceOptions = New-Object 'System.Windows.Forms.Label'
	$labelResumeServiceOptions.AutoSize = $True
	$labelResumeServiceOptions.Font = 'Microsoft Sans Serif, 8.25pt, style=Bold'
	$labelResumeServiceOptions.Location = '13, 20'
	$labelResumeServiceOptions.Name = 'labelResumeServiceOptions'
	$labelResumeServiceOptions.Size = '146, 13'
	$labelResumeServiceOptions.TabIndex = 0
	$labelResumeServiceOptions.Text = 'Resume Service Options'

	#0102 checkboxEnterCredentialResumeService
	$checkboxEnterCredentialResumeService = New-Object 'System.Windows.Forms.CheckBox'
	$checkboxEnterCredentialResumeService.Location = '16, 58'
	$checkboxEnterCredentialResumeService.Name = 'checkboxEnterCredentialResumeService'
	$checkboxEnterCredentialResumeService.Size = '350, 24'
	$checkboxEnterCredentialResumeService.TabIndex = 9
	$checkboxEnterCredentialResumeService.Text = 'Enter Credential'
	$checkboxEnterCredentialResumeService.UseVisualStyleBackColor = $True

	#0103 buttonRunResumeService
	$buttonRunResumeService = New-Object 'System.Windows.Forms.Button'
	$buttonRunResumeService.Location = '13, 110'
	$buttonRunResumeService.Name = 'buttonRunResumeService'
	$buttonRunResumeService.Size = '125, 23'
	$buttonRunResumeService.TabIndex = 10
	$buttonRunResumeService.Text = 'Run'
	$buttonRunResumeService.UseVisualStyleBackColor = $True

	#0104 buttonClearResumeService
	$buttonClearResumeService = New-Object 'System.Windows.Forms.Button'
	$buttonClearResumeService.Location = '153, 110'
	$buttonClearResumeService.Name = 'buttonClearResumeService'
	$buttonClearResumeService.Size = '125, 23'
	$buttonClearResumeService.TabIndex = 11
	$buttonClearResumeService.Text = 'Clear'
	$buttonClearResumeService.UseVisualStyleBackColor = $True
    $buttonClearResumeService.add_Click({ $textboxComputerName.Text = $null
                                          $textboxServiceName.Text = $null
                                          $textboxOutput.Text = $null
                                          $Global:WinCredential = $null
                                          $checkboxEnterCredentialResumeService.Checked = $False})

########################Pause Service Panel########################

	#011 panelPauseService
	$panelPauseService = New-Object 'System.Windows.Forms.Panel'
	$panelPauseService.BackColor = 'InactiveBorder'
	$panelPauseService.BorderStyle = 'FixedSingle'
	$panelPauseService.Location = '612, 198'
	$panelPauseService.Name = 'panelPauseService'
	$panelPauseService.Size = '294, 168'
	$panelPauseService.TabIndex = 0
    $panelPauseService.Visible = $False

	#0111 labelPauseServiceOptions
	$labelPauseServiceOptions = New-Object 'System.Windows.Forms.Label'
	$labelPauseServiceOptions.AutoSize = $True
	$labelPauseServiceOptions.Font = 'Microsoft Sans Serif, 8.25pt, style=Bold'
	$labelPauseServiceOptions.Location = '13, 20'
	$labelPauseServiceOptions.Name = 'labelPauseServiceOptions'
	$labelPauseServiceOptions.Size = '146, 13'
	$labelPauseServiceOptions.TabIndex = 0
	$labelPauseServiceOptions.Text = 'Pause Service Options'

	#0112 checkboxEnterCredentialPauseService
	$checkboxEnterCredentialPauseService = New-Object 'System.Windows.Forms.CheckBox'
	$checkboxEnterCredentialPauseService.Location = '16, 58'
	$checkboxEnterCredentialPauseService.Name = 'checkboxEnterCredentialPauseService'
	$checkboxEnterCredentialPauseService.Size = '350, 24'
	$checkboxEnterCredentialPauseService.TabIndex = 9
	$checkboxEnterCredentialPauseService.Text = 'Enter Credential'
	$checkboxEnterCredentialPauseService.UseVisualStyleBackColor = $True

	#0113 buttonRunPauseService
	$buttonRunPauseService = New-Object 'System.Windows.Forms.Button'
	$buttonRunPauseService.Location = '13, 110'
	$buttonRunPauseService.Name = 'buttonRunPauseService'
	$buttonRunPauseService.Size = '125, 23'
	$buttonRunPauseService.TabIndex = 10
	$buttonRunPauseService.Text = 'Run'
	$buttonRunPauseService.UseVisualStyleBackColor = $True

	#0114 buttonClearPauseService
	$buttonClearPauseService = New-Object 'System.Windows.Forms.Button'
	$buttonClearPauseService.Location = '153, 110'
	$buttonClearPauseService.Name = 'buttonClearPauseService'
	$buttonClearPauseService.Size = '125, 23'
	$buttonClearPauseService.TabIndex = 11
	$buttonClearPauseService.Text = 'Clear'
	$buttonClearPauseService.UseVisualStyleBackColor = $True
    $buttonClearPauseService.add_Click({ $textboxComputerName.Text = $null
                                         $textboxServiceName.Text = $null
                                         $textboxOutput.Text = $null
                                         $Global:WinCredential = $null
                                         $checkboxEnterCredentialPauseService.Checked = $False})


#######################Restart Service Panel###########################

	#012 panelRestartService
	$panelRestartService = New-Object 'System.Windows.Forms.Panel'
	$panelRestartService.BackColor = 'InactiveBorder'
	$panelRestartService.BorderStyle = 'FixedSingle'
	$panelRestartService.Location = '612, 198'
	$panelRestartService.Name = 'panelRestartService'
	$panelRestartService.Size = '294, 168'
	$panelRestartService.TabIndex = 0
    $panelRestartService.Visible = $False

	#0121 labelRestartServiceOptions
	$labelRestartServiceOptions = New-Object 'System.Windows.Forms.Label'
	$labelRestartServiceOptions.AutoSize = $True
	$labelRestartServiceOptions.Font = 'Microsoft Sans Serif, 8.25pt, style=Bold'
	$labelRestartServiceOptions.Location = '13, 20'
	$labelRestartServiceOptions.Name = 'labelRestartServiceOptions'
	$labelRestartServiceOptions.Size = '146, 13'
	$labelRestartServiceOptions.TabIndex = 0
	$labelRestartServiceOptions.Text = 'Restart Service Options'

	#0122 checkboxEnterCredentialRestartService
	$checkboxEnterCredentialRestartService = New-Object 'System.Windows.Forms.CheckBox'
	$checkboxEnterCredentialRestartService.Location = '16, 58'
	$checkboxEnterCredentialRestartService.Name = 'checkboxEnterCredentialRestartService'
	$checkboxEnterCredentialRestartService.Size = '350, 24'
	$checkboxEnterCredentialRestartService.TabIndex = 9
	$checkboxEnterCredentialRestartService.Text = 'Enter Credential'
	$checkboxEnterCredentialRestartService.UseVisualStyleBackColor = $True

	#0123 buttonRunRestartService
	$buttonRunRestartService = New-Object 'System.Windows.Forms.Button'
	$buttonRunRestartService.Location = '13, 110'
	$buttonRunRestartService.Name = 'buttonRunRestartService'
	$buttonRunRestartService.Size = '125, 23'
	$buttonRunRestartService.TabIndex = 10
	$buttonRunRestartService.Text = 'Run'
	$buttonRunRestartService.UseVisualStyleBackColor = $True

	#0124 buttonClearRestartService
	$buttonClearRestartService = New-Object 'System.Windows.Forms.Button'
	$buttonClearRestartService.Location = '153, 110'
	$buttonClearRestartService.Name = 'buttonClearRestartService'
	$buttonClearRestartService.Size = '125, 23'
	$buttonClearRestartService.TabIndex = 11
	$buttonClearRestartService.Text = 'Clear'
	$buttonClearRestartService.UseVisualStyleBackColor = $True
    $buttonClearRestartService.add_Click({ $textboxComputerName.Text = $null
                                           $textboxServiceName.Text = $null
                                           $textboxOutput.Text = $null
                                           $Global:WinCredential = $null
                                           $checkboxEnterCredentialRestartService.Checked = $False})

###################Add objects to form or panel#######################

    #0 Add objects to form
    $FormWinSvce.Controls.Add($labelWinSvceOperation)
	$FormWinSvce.Controls.Add($PanelWinSvceOpe)
	$FormWinSvce.Controls.Add($labelRequiredInformation)
	$FormWinSvce.Controls.Add($panelRequiredInformation)
	$FormWinSvce.Controls.Add($labelOutput)
	$FormWinSvce.Controls.Add($textboxOutput)
	$FormWinSvce.Controls.Add($panelGetService)
	$FormWinSvce.Controls.Add($panelStartService)
	$FormWinSvce.Controls.Add($panelStopService)
	$FormWinSvce.Controls.Add($panelResumeService)
	$FormWinSvce.Controls.Add($panelPauseService)
	$FormWinSvce.Controls.Add($panelRestartService)

    #02 Add objects to WinSvceOpePanel
    $PanelWinSvceOpe.Controls.Add($radiobuttonRestartService)
	$PanelWinSvceOpe.Controls.Add($radiobuttonPauseService)
	$PanelWinSvceOpe.Controls.Add($radiobuttonResumeService)
	$PanelWinSvceOpe.Controls.Add($radiobuttonStopService)
	$PanelWinSvceOpe.Controls.Add($radiobuttonStartService)
	$PanelWinSvceOpe.Controls.Add($radiobuttonGetService)

	#04 Add objects to panelRequiredInformation
	$panelRequiredInformation.Controls.Add($labelEnterServiceNames)
	$panelRequiredInformation.Controls.Add($textboxServiceName)
	$panelRequiredInformation.Controls.Add($labelEnterComputerNames)
	$panelRequiredInformation.Controls.Add($textboxComputerName)

	#07 Add objects to panelGetService
	$panelGetService.Controls.Add($labelGetServiceOptions)
	$panelGetService.Controls.Add($checkboxEnterCredentialGetService)
	$panelGetService.Controls.Add($checkboxDisplayOptionsGetService)
	$panelGetService.Controls.Add($buttonClearGetService)
	$panelGetService.Controls.Add($buttonRunGetService)

    #08 Add objects to panelStartService
    $panelStartService.Controls.Add($labelStartServiceOptions)
	$panelStartService.Controls.Add($checkboxEnterCredentialStartService)
	$panelStartService.Controls.Add($checkboxRequiredServiceStartService)
	$panelStartService.Controls.Add($buttonClearStartService)
	$panelStartService.Controls.Add($buttonRunStartService)

	#09 Add objects to panelStopService
	$panelStopService.Controls.Add($labelStopServiceOptions)
	$panelStopService.Controls.Add($checkboxEnterCredentialStopService)
	$panelStopService.Controls.Add($checkboxDependentServicesStopService)
	$panelStopService.Controls.Add($buttonClearStopService)
	$panelStopService.Controls.Add($buttonRunStopService)

	#010 Add objects to panelResumeService
	$panelResumeService.Controls.Add($labelResumeServiceOptions)
	$panelResumeService.Controls.Add($checkboxEnterCredentialResumeService)
	$panelResumeService.Controls.Add($buttonClearResumeService)
	$panelResumeService.Controls.Add($buttonRunResumeService)

	#011 Add objects to panelPauseService
	$panelPauseService.Controls.Add($labelPauseServiceOptions)
	$panelPauseService.Controls.Add($checkboxEnterCredentialPauseService)
	$panelPauseService.Controls.Add($buttonClearPauseService)
	$panelPauseService.Controls.Add($buttonRunPauseService)

	#012 Add objects to panelRestartService
	$panelRestartService.Controls.Add($labelRestartServiceOptions)
	$panelRestartService.Controls.Add($checkboxEnterCredentialRestartService)
	$panelRestartService.Controls.Add($buttonClearRestartService)
	$panelRestartService.Controls.Add($buttonRunRestartService)

    #################07 panelGetService Output#####################
    $GetServiceOutPut = {
                         if ($checkboxEnterCredentialGetService.checked -and $checkboxDisplayOptionsGetService.Checked){
	                           $textboxOutput.Text =  Get-FormWinSvce -ComputerName $textboxComputerName.Text.Split(",") -ServiceName $textboxServiceName.Text.Split(",") -Credential -DisplayOptoins | Out-String
                         } # end if ($checkboxEnterCredentialGetService.checked -and $checkboxDisplayOptionsGetService.Checked)
	
	                    elseif ($checkboxEnterCredentialGetService.checked){
		                           $textboxOutput.Text = Get-FormWinSvce -ComputerName $textboxComputerName.Text.Split(",") -ServiceName $textboxServiceName.Text.Split(",") -Credential | Out-String
                        } #end elseif ($checkboxEnterCredentialGetService.checked)
		
	            	    elseif ($checkboxDisplayOptionsGetService.checked){
			                    $textboxOutput.Text = Get-FormWinSvce -ComputerName $textboxComputerName.Text.Split(",") -ServiceName $textboxServiceName.Text.Split(",") -DisplayOptoins | Out-String
                        } #end elseif ($checkboxDisplayOptionsGetService.checked)
			
			            else {
				            $textboxOutput.Text = Get-FormWinSvce -ComputerName $textboxComputerName.Text.Split(",") -ServiceName $textboxServiceName.Text.Split(",") | Out-String
                        } #end else 
    } # end $GetServiceOutPut 

    $buttonRunGetService.add_Click($GetServiceOutPut)
		
    #################08 panelStartService Output#####################
    $StartServiceOutPut = {
                         if ($checkboxRequiredServiceStartService.checked -and $checkboxEnterCredentialStartService.Checked){
	                           $textboxOutput.Text =  Start-FormWinSvce -ComputerName $textboxComputerName.Text.Split(",") -ServiceName $textboxServiceName.Text.Split(",") -Credential -RequiredService | Out-String
                         } # end if ($checkboxRequiredServiceStartService.checked -and $checkboxEnterCredentialStartService.Checked)
	
	                    elseif ($checkboxEnterCredentialStartService.checked){
		                           $textboxOutput.Text = Start-FormWinSvce -ComputerName $textboxComputerName.Text.Split(",") -ServiceName $textboxServiceName.Text.Split(",") -Credential | Out-String
                        } #end elseif ($checkboxEnterCredentialStartService.checked)
		
	            	    elseif ($checkboxRequiredServiceStartService.checked){
			                    $textboxOutput.Text = Start-FormWinSvce -ComputerName $textboxComputerName.Text.Split(",") -ServiceName $textboxServiceName.Text.Split(",") -RequiredService | Out-String
                        } #end elseif ($checkboxDisplayOptionsGetService.checked)
			
			            else {
				            $textboxOutput.Text =Start-FormWinSvce -ComputerName $textboxComputerName.Text.Split(",") -ServiceName $textboxServiceName.Text.Split(",") | Out-String
                        } #end else 
    } # end $StartServiceOutPut 

    $buttonRunStartService.add_Click($StartServiceOutPut)

    #################09 panelStopService Output#####################
    $StopServiceOutPut = {
                         if ($checkboxDependentServicesStopService.checked -and $checkboxEnterCredentialStopService.Checked){
	                           $textboxOutput.Text =  Stop-FormWinSvce -ComputerName $textboxComputerName.Text.Split(",") -ServiceName $textboxServiceName.Text.Split(",") -Credential -DependentServices | Out-String
                         } # end if ($checkboxDependentServicesStopService.checked -and $checkboxEnterCredentialStopService.Checked)
	
	                    elseif ($checkboxEnterCredentialStopService.checked){
		                           $textboxOutput.Text = Stop-FormWinSvce -ComputerName $textboxComputerName.Text.Split(",") -ServiceName $textboxServiceName.Text.Split(",") -Credential | Out-String
                        } #end elseif ($checkboxEnterCredentialStopService.checked)
		
	            	    elseif ($checkboxDependentServicesStopService.checked){
			                    $textboxOutput.Text = Stop-FormWinSvce -ComputerName $textboxComputerName.Text.Split(",") -ServiceName $textboxServiceName.Text.Split(",") -DependentServices | Out-String
                        } #end  elseif ($checkboxDependentServicesStopService.checked)
			
			            else {
				          $textboxOutput.Text = Stop-FormWinSvce -ComputerName $textboxComputerName.Text.Split(",") -ServiceName $textboxServiceName.Text.Split(",") | Out-String
                        } #end else 
    } # end $StopServiceOutPut 

    $buttonRunStopService.add_Click($StopServiceOutPut)

    #################10 panelResumeService Output#####################
    $ResumeServiceOutPut = {
                         if ($checkboxEnterCredentialResumeService.Checked){
	                           $textboxOutput.Text =  Resume-FormWinSvce -ComputerName $textboxComputerName.Text.Split(",") -ServiceName $textboxServiceName.Text.Split(",") -Credential | Out-String
                         } # end  if ($checkboxEnterCredentialResumeService.Checked)
	
			             else {
				            $textboxOutput.Text = Resume-FormWinSvce -ComputerName $textboxComputerName.Text.Split(",") -ServiceName $textboxServiceName.Text.Split(",") | Out-String
                         } #end else 
    } # end $ResumeServiceOutPut 

    $buttonRunResumeService.add_Click($ResumeServiceOutPut)

    #################11 panelPauseService Output#####################
    $PauseServiceOutPut = {
                         if ($checkboxEnterCredentialPauseService.Checked){
	                           $textboxOutput.Text =  Pause-FormWinSvce -ComputerName $textboxComputerName.Text.Split(",") -ServiceName $textboxServiceName.Text.Split(",") -Credential | Out-String
                         } # end  if ($checkboxEnterCredentialPauseService.Checked)
	
			             else {
				            $textboxOutput.Text = Pause-FormWinSvce -ComputerName $textboxComputerName.Text.Split(",") -ServiceName $textboxServiceName.Text.Split(",") | Out-String
                         } #end else 
    } # end $PauseServiceOutPut 

    $buttonRunPauseService.add_Click($PauseServiceOutPut)

   #################12 panelRestartService Output#####################
    $RestartServiceOutPut = {
                         if ($checkboxEnterCredentialRestartService.Checked){
	                           $textboxOutput.Text =  Restart-FormWinSvce -ComputerName $textboxComputerName.Text.Split(",") -ServiceName $textboxServiceName.Text.Split(",") -Credential | Out-String
                         } # end  if ($checkboxEnterCredentialRestartService.Checked)
	
			             else {
				            $textboxOutput.Text = Restart-FormWinSvce -ComputerName $textboxComputerName.Text.Split(",") -ServiceName $textboxServiceName.Text.Split(",") | Out-String
                         } #end else 
    } # end $RestartServiceOutPut 

    $buttonRunRestartService.add_Click($RestartServiceOutPut)

	#0 Show the Form
	return $FormWinSvce.ShowDialog()

} #end function Show-FormWinSvce