require 'headless'

module HeadlessHelper
  def start_headless
    @@headless = Headless.new({:video => { :log_file_path => "/tmp/headless-video.log" }})
    @@headless.start 
  end

  def stop_headless
    if defined?(@@headless)
      @@headless.destroy
    end
  end
  module_function :stop_headless
  # ensures that headless is stopped at the end anyway.
  at_exit { HeadlessHelper.stop_headless }

  def start_video_capturing
    @@headless.video.start_capture
  end
  
  def stop_and_store_video(scenario, only_failed=true, destdir="/tmp", filename_prefix="")
    return unless defined?(@@headless)
    if only_failed and not scenario.failed?
      @@headless.video.stop_and_discard
      return
    end
    folder = "#{destdir}/test-scenario-videos"
    if not File.directory? folder
      FileUtils.mkdir_p folder
    end
    if filename_prefix != ""
      filename_prefix="#{filename_prefix}-"
    end
    mov_name = "#{folder}/#{filename_prefix}#{scenario.name.split.join("_")}.mov"
    @@headless.video.stop_and_save mov_name
  end
end
