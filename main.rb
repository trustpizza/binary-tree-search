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

    def find(value, node = @root)
      return nil if node.nil?
      return node if node.data == value
      #until node.data == value
      #  node = node.left_branch if value < node.data
       # node = node.right_branch if value > node.data
      #end
      value < node.data ? find(value, node.left_branch) : find(value, node.right_branch)
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
    def inorder(node = root, out = [], &block)
      return if node.nil?
      
      inorder(node.left_branch, out, &block)
      out.push(block_given? ? block.call(node) : node.data)
      inorder(node.right_branch, out, &block)

      out
    end

    def preorder(node = root, out = [], &block)
      return if node.nil?
      
      out.push(block_given? ? block.call(node) : node.data)
      preorder(node.left_branch, out, &block)
      preorder(node.right_branch, out, &block)

      out
    end
      
    def postorder(node = root)
      return if node.nil?

      postorder(node.left_branch, out, &block)
      postorder(node.right_branch, out, &block)
      out.push(block_given? ? block.call(node) : node.data)

      out
    end

    def height(node = root, count = -1)
      return count if node.nil?

      count += 1
      [height(node.left_branch, count), height(node.right_branch, count)].max
    end

    def depth(node)
      return nil if node.nil?

      current_node = @root
      count = 0
      until current_node.data == node.data
        count += 1
        node.data < current_node.data ? current_node = current_node.left_branch : current_node = current_node.right_branch
      end
      count
    end
  
    def balanced?(node = root)
      #Find the height of the left subtree
      #Find the height of the right subtree
      #If left_branch height is == right_branch height (+- 1) true, else false
      left_height = height(node.left_branch, 0)
      right_height = height(node.right_branch, 0)
      return true if (left_height - right_height).between?(-1,1)
      false
    end

    def rebalance
      values = inorder
      build_tree(values)
    end
    # made by a very smart student of The Odin Project
    def pretty_print(node = root, prefix = '', is_left = true)
        pretty_print(node.right_branch, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right_branch
        puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
        pretty_print(node.left_branch, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left_branch
    end
end
