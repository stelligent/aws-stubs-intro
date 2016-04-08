require 'awsstubs/version'
require 'aws-sdk'

module AwsStubs
  class CloudFormation
    attr_accessor :aws_region
    def initialize(aws_region:)
      @region = aws_region
    end

    # Retrieve a stack based on its name
    # http://docs.aws.amazon.com/sdkforruby/api/Aws/CloudFormation/Client.html#describe_stacks-instance_method
    def retrieve_stack(stack_name:)
      setup_module
      begin
        response = @cfn_client.describe_stacks(stack_name: stack_name).stacks.first
      rescue Aws::CloudFormation::Errors::ValidationError => e
        puts e
        return nil
      end
    end

    # Retrieve a stack resource summary based on the stack's name
    # http://docs.aws.amazon.com/sdkforruby/api/Aws/CloudFormation/Client.html#list_stack_resources-instance_method
    def retrieve_resources(stack_name:)
      setup_module
      fail("#{stack_name} not found") if retrieve_stack(stack_name: stack_name).nil?

      resource_summaries = Array.new
      next_token = nil
      loop do
        pagination = next_token.nil? ? { stack_name: stack_name } : { stack_name: stack_name, next_token: next_token }
        response = @cfn_client.list_stack_resources(pagination)
        resource_summaries += response.stack_resource_summaries
        break if response.next_token.nil?
        next_token = response.next_token
      end
      resource_summaries
    end

    # Retrieve a specific stack resource
    # http://docs.aws.amazon.com/sdkforruby/api/Aws/CloudFormation/Client.html#describe_stack_resources-instance_method
    def retrieve_resource(stack_name:, logical_resource_id:)
      setup_module
      fail("#{stack_name} not found") if retrieve_stack(stack_name: stack_name).nil?

      @cfn_client.describe_stack_resource(
        stack_name: stack_name,
        logical_resource_id: logical_resource_id
      ).stack_resource_detail
    end

    def setup_module()
      @cfn_client ||= Aws::CloudFormation::Client.new(region: @region)
    end
  end
end
