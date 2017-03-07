CXX = g++
CXXFLAGS = -std=c++11 -std=gnu++11 -pthread -I/usr/local/include
LDFLAGS += -L/usr/local/lib `pkg-config --libs grpc++ grpc`           \
		   -Wl,--no-as-needed -lgrpc++_reflection -Wl,--as-needed     \
		   -lprotobuf -lpthread -ldl

all: server client 

calc.grpc.pb.cc: calc.proto
	protoc -I=. --grpc_out=. --plugin=protoc-gen-grpc=`which grpc_cpp_plugin` calc.proto

calc.pb.cc: calc.proto
	protoc -I=. --cpp_out=. calc.proto

server: calc_server.cc calc.grpc.pb.cc calc.pb.cc
	$(CXX) $(CXXFLAGS) -o server calc_server.cc calc.grpc.pb.cc calc.pb.cc $(LDFLAGS)

client: calc_client.cc calc.grpc.pb.cc calc.pb.cc
	$(CXX) $(CXXFLAGS) -o client calc_client.cc calc.grpc.pb.cc calc.pb.cc $(LDFLAGS)

multi: calc_client_multi.cc calc.grpc.pb.cc calc.pb.cc
	$(CXX) $(CXXFLAGS) -o multi calc_client_multi.cc calc.grpc.pb.cc calc.pb.cc $(LDFLAGS)

clean:
	rm *.pb.cc *.pb.h server client
