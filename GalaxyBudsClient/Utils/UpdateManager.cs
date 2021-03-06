using System;
using System.Drawing;
using System.Linq;
using System.Reflection;
using System.Threading.Tasks;
using GalaxyBudsClient.Interface.Pages;
using NetSparkleUpdater;
using NetSparkleUpdater.Configurations;
using NetSparkleUpdater.Enums;
using NetSparkleUpdater.Events;
using NetSparkleUpdater.SignatureVerifiers;
using Serilog;

namespace GalaxyBudsClient.Utils
{
    public class UpdateManager
    {
        private static readonly object Padlock = new object();
        private static UpdateManager? _instance;
        public static UpdateManager Instance
        {
            get
            {
                lock (Padlock)
                {
                    return _instance ??= new UpdateManager();
                }
            }
        }

        public static void Init()
        {
            lock (Padlock)
            { 
                _instance ??= new UpdateManager();
            }
        }

        public SparkleUpdater Core => _sparkle;
        
        private readonly SparkleUpdater _sparkle;

        public UpdateManager()
        {
            _sparkle = new SparkleUpdater("https://timschneeberger.me/updates/galaxybudsclient/appcast.xml", new Ed25519Checker(SecurityMode.Unsafe))
            {
                SecurityProtocolType = System.Net.SecurityProtocolType.Tls12
            };
            _sparkle.StartLoop(false, false);
        }

        public async Task<UpdateStatus> DoManualCheck()
        {
            var result = await _sparkle.CheckForUpdatesAtUserRequest();
            if (result == null)
            {
                return UpdateStatus.CouldNotDetermine;
            }

            if (result.Status == UpdateStatus.UpdateAvailable)
            { 
                MainWindow.Instance.UpdatePage.SetUpdate(result.Updates, false);
            }
            
            return result.Status;
        }

        public async Task SilentCheck()
        {
            var result = await _sparkle.CheckForUpdatesQuietly();

            if (result?.Status == UpdateStatus.UpdateAvailable)
            { 
                MainWindow.Instance.UpdatePage.SetUpdate(result.Updates, true);
            }
        }
    }
}