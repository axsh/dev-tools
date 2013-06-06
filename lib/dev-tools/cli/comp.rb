# -*- coding: utf-8 -*-

module DevTools::Cli
  class Comp < Thor
    namespace :comp

    no_tasks {
      def start_stop(project,comp,node,action)
        #action should be :start, :stop or restart
        if node
          comps = if comp
            [DevTools::Node.new(node).get_comp(project,comp)]
          else
            DevTools::Node.new(node).comps[project]
          end

          comps.each { |c|
            c.send(action)
          }
        else
          DevTools::Component.enabled(project,comp).each {|c| c.send(action)}
        end
      end
    }

    [:start, :stop, :restart].each { |action|
      capital_action = action.to_s.slice(0,1).capitalize + action.to_s.slice(1..-1)

      desc "#{action} #{DevTools::Constants::Config::PROJECTS.join("|")} [options]", "#{capital_action}s components on nodes. Running this without options #{action}s all components on all nodes for a project."
      method_option :comp, :type => :string, :desc => "The name of the component we want to #{action}.", :aliases => :c
      method_option :node, :type => :string, :desc => "The name of the node whose components we want to #{action}.", :aliases => :n
      define_method(action) do |project|
        start_stop(project,options[:comp],options[:node],action)
      end
    }
  end
end
