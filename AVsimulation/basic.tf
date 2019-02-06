
# Azure Batch Pool
resource "azurerm_resource_group" "test" {
  name     = "testaccbatch"
  location = "westeurope"
}

resource "azurerm_storage_account" "test" {
  name                     = "testaccsa"
  resource_group_name      = "${azurerm_resource_group.test.name}"
  location                 = "${azurerm_resource_group.test.location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_batch_account" "test" {
  name                 = "testaccbatch"
  resource_group_name  = "${azurerm_resource_group.test.name}"
  location             = "${azurerm_resource_group.test.location}"
  pool_allocation_mode = "BatchService"
  storage_account_id   = "${azurerm_storage_account.test.id}"

  tags {
    env = "test"
  }
}

resource "azurerm_batch_pool" "test" {
  name                = "testaccpool"
  resource_group_name = "${azurerm_resource_group.test.name}"
  account_name        = "${azurerm_batch_account.test.name}"
  display_name        = "Test Acc Pool Auto"
  vm_size             = "Standard_A1"
  node_agent_sku_id   = "batch.node.ubuntu 16.04"

  auto_scale {
    evaluation_interval = "PT15M"
    formula             = <<EOF
      startingNumberOfVMs = 1;
      maxNumberofVMs = 5;
      pendingTaskSamplePercent = $PendingTasks.GetSamplePercent(180 * TimeInterval_Second);
      pendingTaskSamples = pendingTaskSamplePercent < 70 ? startingNumberOfVMs : avg($PendingTasks.GetSample(180 *   TimeInterval_Second));
      $TargetDedicatedNodes=min(maxNumberofVMs, pendingTaskSamples);
EOF
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04.0-LTS"
    version   = "latest"
  }

  start_task {
    command_line         = "echo Hello World from $USER"
    max_task_retry_count = 1
    wait_for_success     = true

    environment {
      env = "TEST"
    }

    user_identity {
      auto_user {
        elevation_level = "NonAdmin"
        scope           = "Task"
      }
    }
  }
}