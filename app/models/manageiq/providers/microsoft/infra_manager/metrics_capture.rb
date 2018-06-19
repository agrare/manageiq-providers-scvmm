class ManageIQ::Providers::Microsoft::InfraManager::MetricsCapture < ManageIQ::Providers::BaseManager::MetricsCapture
  def perf_collect_metrics(interval_name, start_time = nil, end_time = nil)
    return {}, {} unless valid_ems_credentials?

    results = target.ext_management_system.class.run_powershell_script(metrics_connection, metrics_capture_script)
  end

  private

  def valid_ems_credentials?
    if target.ext_management_system.nil?
      _log.warn("#{target_log_header} is not connected to an EMS")
      return false
    end

    unless target.ext_management_system.authentication_status_ok?(:metrics)
      _log.warn("#{target_log_header} does not have valid metrics credentials")
      return false
    end
    
    true
  end

  def target_log_header
    "[#{target.class.name}], [#{target.id}], [#{target.name}]"
  end

  def metrics_connection
    target.ext_management_system.connect(:auth_type => :metrics)
  end

  def metrics_capture_script
    @metrics_capture_script ||= begin
      script_path = File.join(File.dirname(__FILE__), 'infra_manager/ps_scripts/metrics_capture.ps1')
      IO.read(script_path)
    end
  end
end
