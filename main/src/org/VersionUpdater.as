package org
{

	import air.update.ApplicationUpdaterUI;
	import air.update.events.StatusUpdateErrorEvent;
	import air.update.events.StatusUpdateEvent;
	import air.update.events.UpdateEvent;

	import flash.desktop.NativeApplication;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.filesystem.File;

	public class VersionUpdater
	{

		private var appUpdater:ApplicationUpdaterUI;

		public function VersionUpdater()
		{
			init();
		}

		private function init():void
		{
			appUpdater = new ApplicationUpdaterUI();
			appUpdater.configurationFile = new File("app:/config/update-config.xml");
			appUpdater.addEventListener(UpdateEvent.INITIALIZED, onInit);
			appUpdater.initialize();
		}

		private function onInit(ev:UpdateEvent):void
		{
			checkForUpdate();
		}

		public function checkForUpdate():void
		{
			appUpdater.checkNow();
		}
	}
}

