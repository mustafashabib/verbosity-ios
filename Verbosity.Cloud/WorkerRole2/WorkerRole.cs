using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Net;
using System.Threading;
using Microsoft.WindowsAzure;
using Microsoft.WindowsAzure.Diagnostics;
using Microsoft.WindowsAzure.ServiceRuntime;
using Microsoft.WindowsAzure.StorageClient;

namespace Verbosity.GameMatchWorkerRole
{
    public class WorkerRole : RoleEntryPoint
    {
        private CloudQueue _queue;
        private CloudTableClient _table;
        private enum MessageType
        {
            //game invite events
            INVITED_TO_GAME = 0,
            REJECTED_INVITE = 1,
            ACCEPTED_INVITE = 2,
            //game in progress events
            GAME_ROUND_COMPLETE = 3,
            GAME_COMPLETE = 4,
            //random game event
            IN_WAITING_ROOM = 5

        }
        private const int MESSAGE_TYPE = 0;
        private const int MESSAGE_FROM = 1;
        private const int MESSAGE_TO = 2;
        private const int MESSAGE_DETAILS = 3;

        public override void Run()
        {
            // This is a sample worker implementation. Replace with your logic.
            Trace.WriteLine("Betelnutgames APN Worker Role started", "Information");

          
            while (true)
            {
                try
                {
                    Trace.WriteLine("Reading latest push notifications", "Information");
                    CloudQueueMessage msg = _queue.GetMessage();
                    if (msg != null)
                    {
                        var messageParts = msg.AsString.Split('|');
                        MessageType message_type = (MessageType)Enum.Parse(typeof(MessageType), messageParts[MESSAGE_TYPE]);
                        Guid message_from = (Guid)Guid.Parse(messageParts[MESSAGE_FROM]); 
                        Guid message_to = (Guid)Guid.Parse(messageParts[MESSAGE_TO]);
                        dynamic json_details = SimpleJson.DeserializeObject(messageParts[MESSAGE_DETAILS]);

                        switch (message_type)
                        {
                            case MessageType.INVITED_TO_GAME:
                                //send push to the TO recipient
                                break;
                                case Mess

                        }
                    }

                }
                catch (StorageClientException e)
                {
                    Trace.TraceError("Exception when processing queue item. Message: '{0}'", e.Message);
                }
                finally
                {
                    System.Threading.Thread.Sleep(5000);
                }
            }
        }

        public override bool OnStart()
        {
            // Set the maximum number of concurrent connections 
            ServicePointManager.DefaultConnectionLimit = 12;

            // For information on handling configuration changes
            // see the MSDN topic at http://go.microsoft.com/fwlink/?LinkId=166357.
            CloudStorageAccount.SetConfigurationSettingPublisher((configName, configSetter) =>
            {
                configSetter(RoleEnvironment.GetConfigurationSettingValue(configName));
            });
            var storageAccount = CloudStorageAccount.FromConfigurationSetting("DataConnectionString");
            //initialize queue
            CloudQueueClient queueStorage = storageAccount.CreateCloudQueueClient();
            _queue = queueStorage.GetQueueReference("bngapn_verbosity");
            Trace.TraceInformation("Creating queue...");

            CloudTableClient tableStorage = storageAccount.CreateCloudTableClient();

            bool storageInitialized = false;
            while (!storageInitialized)
            {
                try
                {
                    _queue.CreateIfNotExist();
                    storageInitialized = true;
                }
                catch (StorageClientException e)
                {
                    if (e.ErrorCode == StorageErrorCode.TransportError)
                    {
                        Trace.TraceError("Storage services initialization failure. "
            + "Check your storage account configuration settings. If running locally, "
            + "ensure that the Development Storage service is running. Message: '{0}'", e.Message);
                        System.Threading.Thread.Sleep(5000);
                    }
                    else
                    {
                        throw;
                    }
                }
            }

            return base.OnStart();
        }
    }
}
