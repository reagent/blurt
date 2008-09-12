datetime_formats = {:post => '%m:%d:%Y'}

ActiveSupport::CoreExtensions::Date::Conversions::DATE_FORMATS.merge!(datetime_formats)
ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS.merge!(datetime_formats)