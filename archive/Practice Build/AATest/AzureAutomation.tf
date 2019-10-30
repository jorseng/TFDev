resource "azurerm_automation_account" "azauto" {
  name                = var.azauto
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  sku {
    name = "Basic"
  }
}

resource "azurerm_automation_dsc_configuration" "dsc_config" {
  name                    = "HelloWorld"
  automation_account_name = azurerm_automation_account.azauto.name
  resource_group_name     = azurerm_resource_group.rg.name
  location                = azurerm_resource_group.rg.location
  content_embedded        = <<BODY
    Configuration HelloWorld {

        # Import the module that contains the File resource.
        Import-DscResource -ModuleName PsDesiredStateConfiguration

        # The Node statement specifies which targets to compile MOF files for, when this configuration is executed.
        Node vmAA {

            # The File resource can ensure the state of files, or copy them from a source to a destination with persistent updates.
            File HelloWorld {
                DestinationPath = "C:\DSCDemo\HelloWorld.txt"
                Ensure = "Present"
                Contents   = "Hello World from DSC!"
            }
        }
    }
  BODY
}

resource "azurerm_automation_dsc_nodeconfiguration" "dsc_nodeconfig" {
  name                      = "HelloWorld.vmAA"
  automation_account_name   = azurerm_automation_account.azauto.name
  resource_group_name       = azurerm_resource_group.rg.name
  depends_on                = [azurerm_automation_dsc_configuration.dsc_config]
  content_embedded          = <<mofcontent
        instance of MSFT_FileDirectoryConfiguration as $MSFT_FileDirectoryConfiguration1ref
        {
            ResourceID = "[File]HelloWorld";
            Ensure = "Present";
            Contents = "Hello World from DSC!";
            DestinationPath = "C:\\DSCDemo\\HelloWorld.txt";
            ModuleName = "PSDesiredStateConfiguration";
            SourceInfo = "C:\\Users\\jorseng\\OneDrive - Infront Consulting APAC\\Infront Consulting\\TFDev\\AATest\\DSC_HelloWorld.ps1::10::9::File";
            ModuleVersion = "1.0";
            ConfigurationName = "HelloWorld";
        };
        instance of OMI_ConfigurationDocument
        {
            Version="2.0.0";
            MinimumCompatibleVersion = "1.0.0";
            CompatibleVersionAdditionalProperties= {"Omi_BaseResource:ConfigurationName"};
            Author="jorseng";
            GenerationDate="07/21/2019 23:55:49";
            GenerationHost="LAPTOP-JGNDMEA0";
            Name="HelloWorld";
        };
  mofcontent
}


