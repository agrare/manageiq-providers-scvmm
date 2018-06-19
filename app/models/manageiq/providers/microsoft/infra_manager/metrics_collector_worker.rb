class ManageIQ::Providers::Microsoft::InfraManager::MetricsCollectorWorker < ManageIQ::Providers::BaseManager::MetricsCollectorWorker
  require_nested :Runner
  self.default_queue_name = "scvmm"

  def friendly_name
    @friendly_name ||= "C&U Metrics Collector for SCVMM"
  end
end
