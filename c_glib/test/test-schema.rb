# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

class TestSchema < Test::Unit::TestCase
  def test_equal
    fields1 = [
      Arrow::Field.new("enabled", Arrow::BooleanDataType.new),
    ]
    fields2 = [
      Arrow::Field.new("enabled", Arrow::BooleanDataType.new),
    ]
    assert_equal(Arrow::Schema.new(fields1),
                 Arrow::Schema.new(fields2))
  end

  def test_field
    field = Arrow::Field.new("enabled", Arrow::BooleanDataType.new)
    schema = Arrow::Schema.new([field])
    assert_equal("enabled", schema.get_field(0).name)
  end

  sub_test_case("#get_field_by_name") do
    def test_found
      field = Arrow::Field.new("enabled", Arrow::BooleanDataType.new)
      schema = Arrow::Schema.new([field])
      assert_equal("enabled", schema.get_field_by_name("enabled").name)
    end

    def test_not_found
      field = Arrow::Field.new("enabled", Arrow::BooleanDataType.new)
      schema = Arrow::Schema.new([field])
      assert_nil(schema.get_field_by_name("nonexistent"))
    end
  end

  sub_test_case("#get_field_index") do
    def test_found
      field = Arrow::Field.new("enabled", Arrow::BooleanDataType.new)
      schema = Arrow::Schema.new([field])
      assert_equal(0, schema.get_field_index("enabled"))
    end

    def test_not_found
      field = Arrow::Field.new("enabled", Arrow::BooleanDataType.new)
      schema = Arrow::Schema.new([field])
      assert_equal(-1, schema.get_field_index("nonexistent"))
    end
  end

  def test_n_fields
    fields = [
      Arrow::Field.new("enabled", Arrow::BooleanDataType.new),
      Arrow::Field.new("required", Arrow::BooleanDataType.new),
    ]
    schema = Arrow::Schema.new(fields)
    assert_equal(2, schema.n_fields)
  end

  def test_fields
    fields = [
      Arrow::Field.new("enabled", Arrow::BooleanDataType.new),
      Arrow::Field.new("required", Arrow::BooleanDataType.new),
    ]
    schema = Arrow::Schema.new(fields)
    assert_equal(["enabled", "required"],
                 schema.fields.collect(&:name))
  end

  def test_to_s
    fields = [
      Arrow::Field.new("enabled", Arrow::BooleanDataType.new),
      Arrow::Field.new("required", Arrow::BooleanDataType.new),
    ]
    schema = Arrow::Schema.new(fields)
    assert_equal(<<-SCHEMA.chomp, schema.to_s)
enabled: bool
required: bool
    SCHEMA
  end

  def test_add_field
    fields = [
      Arrow::Field.new("enabled", Arrow::BooleanDataType.new),
      Arrow::Field.new("required", Arrow::BooleanDataType.new)
    ]
    schema = Arrow::Schema.new(fields)
    new_field = Arrow::Field.new("new", Arrow::BooleanDataType.new)
    new_schema = schema.add_field(1, new_field)
    assert_equal(<<-SCHEMA.chomp, new_schema.to_s)
enabled: bool
new: bool
required: bool
    SCHEMA
  end

  def test_remove_field
    fields = [
      Arrow::Field.new("enabled", Arrow::BooleanDataType.new),
      Arrow::Field.new("required", Arrow::BooleanDataType.new)
    ]
    schema = Arrow::Schema.new(fields)
    new_schema = schema.remove_field(0)
    assert_equal(<<-SCHEMA.chomp, new_schema.to_s)
required: bool
    SCHEMA
  end

  def test_replace_field
    fields = [
      Arrow::Field.new("enabled", Arrow::BooleanDataType.new),
      Arrow::Field.new("required", Arrow::BooleanDataType.new)
    ]
    schema = Arrow::Schema.new(fields)
    new_field = Arrow::Field.new("new", Arrow::BooleanDataType.new)
    new_schema = schema.replace_field(1, new_field)
    assert_equal(<<-SCHEMA.chomp, new_schema.to_s)
enabled: bool
new: bool
    SCHEMA
  end
end
