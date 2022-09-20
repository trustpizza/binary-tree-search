class Node
    attr_accessor :left_branch, :right_branch, :data
  
    def initialize(data)
      @data = data
      @left_branch = nil
      @right_branch = nil
    end
end

class Tree
    attr_accessor :root, :data
  
    def initialize(array)
      @data = array.sort.uniq
      @root = build_tree(data)
    end

    def build_tree(array)
        return nil if array.empty?
        
        middle = (array.length / 2).round
        
        root = Node.new(array[middle])
        
        root.left_branch = build_tree(array[0...middle])
        root.right_branch = build_tree(array[(middle + 1)..-1])

        root
    end

    def insert(value, node = root)
        return nil if value == node.data
        # Take the value
        # Assess each node in the tree starting with the root
        # If > root, go right, otherwise go left
        # Recurse until there are no more branches, then set as current_root.left_branch
        if value < node.data
            node.left_branch.nil? ? node.left_branch = Node.new(value) : insert(value, node.left_branch)
        else
            node.right_branch.nil? ? node.right_branch = Node.new(value) : insert(value, node.left_branch)
        end
    end

    def delete(value, node = root)
        return nil if node.nil?

        if value < node.data
            if node.left_branch.data == value
                # Removes leaves from tree
                if node.left_branch.left_branch.nil? && node.left_branch.right_branch.nil? 
                    node.left_branch.data = nil
                    node.left_branch = nil
                elsif  node.left_branch.left_branch.nil?# Removes branches with 1 leaf
                    node.left_branch.data = nil
                    node.left_branch = node.left_branch.right_branch
                else
                    node.data = min_value(node.right_branch)
                    delete(value, node.right_branch)
                end
            else 
                delete(value, node.left_branch)
            end
        end

        if value > node.data            
            if node.right_branch.data == value
                #removes leaves from tree
                if node.left_branch.left_branch.nil? && node.left_branch.right_branch.nil?
                    node.right_branch.data = nil
                    node.left_branch = nil
                elsif node.right_branch.right_branch.nil?
                    node.right_branch.data = nil 
                    node.right_branch = node.right_branch.left_branch
                else
                    # Take the lowest value from the right side of the tree
                    # That overwrites the node you're deleting
                    # Delete the lowest value you took, but make the starting node the new node of the same value
                    node.data = min_value(node.right_branch)
                    delete(value, node.right_branch)
                end
            else
                delete(value, node.right_branch)
            end
        end
    end

    def min_value(node)
        current_node = node

        until current_node.left_branch.nil?
            current_node = current_node.left_branch
        end
        
        current_node
    end


    def pretty_print(node = root, prefix = '', is_left = true)
        pretty_print(node.right_branch, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right_branch
        puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
        pretty_print(node.left_branch, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left_branch
      end
end


new_tree = Tree.new([1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324])
new_tree.pretty_print

new_tree.delete(7)

new_tree.pretty_print