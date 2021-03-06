#
# Sonar, entreprise quality control tool.
# Copyright (C) 2008-2012 SonarSource
# mailto:contact AT sonarsource DOT com
#
# Sonar is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 3 of the License, or (at your option) any later version.
#
# Sonar is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with Sonar; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02
#
module WidgetPropertiesHelper

  def property_value_field(definition, value)
    val=value || definition.defaultValue()
    if definition.type.name()==WidgetProperty::TYPE_INTEGER
      text_field_tag definition.key(), val, :size => 10

    elsif definition.type.name()==WidgetProperty::TYPE_FLOAT
      text_field_tag definition.key(), val, :size => 10

    elsif definition.type.name()==WidgetProperty::TYPE_BOOLEAN
      check_box_tag definition.key(), "true", val=='true'

    elsif definition.type.name()==WidgetProperty::TYPE_METRIC
      select_tag definition.key(), options_grouped_by_domain(Metric.all.select{|m| m.display?}.sort_by{|m| m.short_name}, val, :include_empty => true)

    elsif definition.type.name()==WidgetProperty::TYPE_STRING
      text_field_tag definition.key(), val, :size => 10

    elsif definition.type.name()==WidgetProperty::TYPE_FILTER
      user_filters = options(value, ::Filter.find(:all, :conditions => ['user_id=?', current_user.id]).sort_by(&:id))
      shared_filters = options(value, ::Filter.find(:all, :conditions => ['(user_id<>? or user_id is null) and shared=?', current_user.id, true]).sort_by(&:id))

      select_tag definition.key(), option_group('My Filters', user_filters) + option_group('Shared Filters', shared_filters)

    else
      hidden_field_tag definition.key()
    end
  end

  def resource_value_field(value)
    select_tag 'resource_id', options(value, Project.all(:conditions => {:scope => 'PRJ', :qualifier => 'TRK'}))
  end

  def options(value, values)
    values.collect { |f| "<option value='#{f.id}'" + (value.to_s == f.id.to_s ? " selected='selected'" : "") + ">#{f.name}</option>" }.to_s
  end

  def option_group(name, options)
    options.empty? ? '' : "<optgroup label=\"#{name}\">" + options + "</optgroup>"
  end

end
