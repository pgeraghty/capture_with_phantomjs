class CaptureElement
  CAPTURE = Rails.root.join('lib', 'capture-element.coffee')
  TMP_DIRECTORY = Rails.root.join('tmp', '')

  def initialize viewport=nil, file_or_ext=nil
    @file = file_or_ext.present? ? (file_or_ext.length == 3 ? clean_filename(file_or_ext) : TMP_DIRECTORY.join(file_or_ext).to_s) : clean_filename
    @viewport = viewport
  end

  def capture_url url, id = nil
    filename = clean_filename
    `#{CAPTURE} "#{url}" "#{filename}" "#{id}"#{@viewport.present? ? " #{@viewport}" : ''}`
    filename
  end

  def capture content, id = nil
    Tempfile.open([self.class.to_s.underscore, '.html']) do |f|
      f.write content
      f.flush
      `#{CAPTURE} "#{f.path}" "#{@file}" "#{id}"#{@viewport.present? ? " #{@viewport}" : ''}`
      f.unlink
    end
    @file
  end

  private
  def clean_filename ext='png'
    "#{TMP_DIRECTORY}/captured_element#{Time.now.to_i+(@viewport.to_i+1)*Random.new.rand(99999)}.#{ext}"
  end
end