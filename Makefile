SWAGGER_PORT ?= 8081

.PHONY: swagger

# View api/openapi.yaml in Swagger UI at http://localhost:$(SWAGGER_PORT)
swagger:
	docker run --rm -p $(SWAGGER_PORT):8080 \
		-e SWAGGER_JSON=/spec/openapi.yaml \
		-v "$(CURDIR)/api:/spec" \
		swaggerapi/swagger-ui
