$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'awsstubs'

RSpec::Matchers.define :struct_match do |expected|
  match do |actual|
    json_match?(expected: expected, actual: actual)
  end

  def json_match?(expected:, actual:)
    expected.to_json.eql?(actual.to_json)
  end
end

def stubbed_stacks(how_many: 1)
	stub_stacks = []
	(1..how_many).each { |i|
		stub_stacks +=  [
		  Aws::CloudFormation::Types::Stack.new(
		    stack_id: 'uniquestackid#{i}',
		    stack_name: 'stackname#{i}',
		    stack_status: 'CREATION_COMPLETE',
		    description: 'stackdescription#{i}',
		    creation_time: Time.new,
		    parameters: [],
		    capabilities: [],
		    outputs: [],
		    notification_arns: [],
		    tags: []
		  )
		]
	}
	stub_stacks
end

def stubbed_stack_summaries(how_many: 1)
	stub_resource_summaries = []
	(1..how_many).each { |i|
	  stub_resource_summaries +=  [
	    Aws::CloudFormation::Types::StackResourceSummary.new(
	      last_updated_timestamp: Time.new,
	      logical_resource_id: "resourceid#{i}",
	      physical_resource_id: "resourcename#{i}",
	      resource_status: 'CREATE_COMPLETE',
	      resource_status_reason: 'easy peasey',
	      resource_type: "Aws::Type::#{i}"
	    )
	  ]
	}
	stub_resource_summaries
end

def stubbed_resource_detail(stack:, resource_summary:)
	stub_resource_detail = Aws::CloudFormation::Types::StackResourceDetail.new(
	  description: 'You just WISH you had this resource',
	  last_updated_timestamp: Time.new,
	  logical_resource_id: resource_summary.logical_resource_id,
	  metadata: nil,
	  physical_resource_id: resource_summary.physical_resource_id,
	  resource_status: resource_summary.resource_status,
	  resource_status_reason: resource_summary.resource_status_reason,
	  resource_type: resource_summary.resource_type,
	  stack_id: stack.stack_id,
	  stack_name: stack.stack_name
	)
	stub_resource_detail
end
