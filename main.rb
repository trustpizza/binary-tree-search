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
                    node.right_branch.data = min_value(node.right_branch)
                    delete(node.right_branch.data, node.right_branch.right_branch)
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
                    node.right_branch.data = min_value(node.right_branch)
                    delete(node.right_branch.data, node.right_branch.right_branch)
                end
            else
                delete(value, node.right_branch)
            end
        end
    end

    def min_value(node) # finds the smallest value in the RIGHT branch
        current_node = node

        until current_node.left_branch.nil?
            current_node = current_node.right_branch.left_branch
        end
        
        current_node.data
    end

    def find(value, node = root)
      return nil if node.nil?
      
      node = @root
      until node.data == value
        node = node.left_branch if value < node.data
        node = node.right_branch if value > node.data
      end
      node
    end

    def level_order(node = root, queue = [])
      puts "#{node.data}"

      queue << node.left_branch unless node.left_branch.nil?
      queue << node.right_branch unless node.right_branch.nil?
      
      return if queue.empty?
      level_order(queue.shift, queue)
    end  
      #Visit the first value in the queue 
      #First visit the left value in that node
      # Put that node into the queue
      # Second visit the left value in that node
      # Put that node into the queue
      # Remove the first item from the queue
    def inorder(node = root)
      unless node.nil?
        inorder(node.left_branch)
        puts node.data
        inorder(node.right_branch)
      end 
    end

    def preorder(node = root)
      unless node.nil?
        puts node.data
        preorder(node.left_branch)
        preorder(node.right_branch)
      end
    end
      
    def postorder(node = root)
      unless node.nil?
        postorder(node.left_branch)
        postorder(node.right_branch)
        p node.data
      end
    end
  
    def pretty_print(node = root, prefix = '', is_left = true)
        pretty_print(node.right_branch, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right_branch
        puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
        pretty_print(node.left_branch, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left_branch
    end
end


new_tree = Tree.new([1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324])
new_tree.pretty_print


