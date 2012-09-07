module HeadLessHelper
  at_exit { @@headless.destroy unless @@headless.nil? }

  def start_headless
    @@headless = Headless.new
    @@headless.start 
  end

  def start_video_capturing
    @@headless.video.start_capture
  end
  
  def stop_and_store_video(scenario, only_failed=true, destdir="/tmp", filename_prefix="")
    if only_failed and not scenario.failed?
      @@headless.video.stop_and_discard
      return
    end
    folder = "#{folder}/test-scenario-videos"
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
